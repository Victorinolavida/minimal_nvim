return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function(_, opts)
		require("obsidian").setup(opts)

		local vault = vim.fn.expand("~/obsidian-vault")
		local sync_interval_ms = 5 * 60 * 1000 -- 5 minutes
		local last_synced_at = nil

		local function elapsed_since_last_sync()
			if not last_synced_at then return nil end
			local secs = math.floor((vim.uv.now() - last_synced_at) / 1000)
			if secs < 60 then return secs .. "s ago" end
			return math.floor(secs / 60) .. "m ago"
		end

		local function sync_vault(direction)
			local cmd = direction == "pull"
				and string.format("git -C %s pull --rebase origin main", vault)
				or string.format(
					"git -C %s add -A && git -C %s commit -m 'nvim: manual sync' && git -C %s push",
					vault, vault, vault
				)
			local stderr_lines = {}
			vim.fn.jobstart(cmd, {
				stderr_buffered = true,
				on_stderr = function(_, data)
					for _, line in ipairs(data) do
						if line:match("^error:") or line:match("^fatal:") or line:match("rejected") or line:match("^hint:") then
							table.insert(stderr_lines, line)
						end
					end
				end,
				on_exit = function(_, code)
					if code == 0 then
						local elapsed = elapsed_since_last_sync()
						local msg = elapsed
							and string.format("vault %s done (last: %s)", direction, elapsed)
							or string.format("vault %s done", direction)
						last_synced_at = vim.uv.now()
						vim.notify(msg, vim.log.levels.INFO)
					else
						local detail = #stderr_lines > 0
							and ("\n" .. table.concat(stderr_lines, "\n"))
							or "\n(no error details captured)"
						vim.notify(
							string.format("vault %s failed (exit %d)%s", direction, code, detail),
							vim.log.levels.ERROR
						)
					end
				end,
			})
		end

		local timer_started_at = vim.uv.now()
		local timer = vim.uv.new_timer()
		timer:start(sync_interval_ms, sync_interval_ms, function()
			vim.schedule(function()
				sync_vault("push")
			end)
		end)

		local function show_sync_status()
			local now = vim.uv.now()
			local elapsed_ms = now - (last_synced_at or timer_started_at)
			local next_ms = sync_interval_ms - (elapsed_ms % sync_interval_ms)
			local next_secs = math.floor(next_ms / 1000)
			local next_str = next_secs >= 60
				and string.format("%dm %ds", math.floor(next_secs / 60), next_secs % 60)
				or string.format("%ds", next_secs)
			local last_str = last_synced_at
				and elapsed_since_last_sync()
				or "never"
			vim.notify(
				string.format("vault sync — last: %s | next in: %s", last_str, next_str),
				vim.log.levels.INFO
			)
		end

		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				timer:stop()
				timer:close()
			end,
		})

		local function set_obsidian_keymaps(buf)
			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
			end
			map("<leader>on", "<cmd>ObsidianNew<cr>",                    "Obsidian New")
			map("<leader>oo", "<cmd>ObsidianOpen<cr>",                   "Obsidian Open")
			map("<leader>os", "<cmd>ObsidianSearch<cr>",                 "Obsidian Search")
			map("<leader>ob", "<cmd>ObsidianBacklinks<cr>",              "Obsidian Backlinks")
			map("<leader>ot", "<cmd>ObsidianToday<cr>",                  "Obsidian Today")
			map("<leader>of", "<cmd>ObsidianFollowLink<cr>",             "Obsidian Follow Link")
			map("<leader>op", function() sync_vault("pull") end,         "Obsidian Pull")
			map("<leader>oP", function() sync_vault("push") end,         "Obsidian Push")
			map("<leader>oi", show_sync_status,                          "Obsidian Sync Info")
		end

		-- Apply to the buffer that triggered plugin load (FileType already fired)
		set_obsidian_keymaps(vim.api.nvim_get_current_buf())

		-- Apply to all future markdown buffers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(event)
				set_obsidian_keymaps(event.buf)
			end,
		})

		-- Auto-sync vault on save
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = vault .. "/**/*.md",
			callback = function(event)
				if not event.file:find(vault, 1, true) then
					return
				end

				local cmd = string.format(
					"git -C %s add -A && git -C %s commit -m 'nvim: auto-sync' && git -C %s push",
					vault, vault, vault
				)

				vim.fn.jobstart(cmd, {
					detach = true,
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("vault synced", vim.log.levels.INFO)
						else
							vim.notify("vault sync failed", vim.log.levels.WARN)
						end
					end,
				})
			end,
		})
	end,
	opts = {
		workspaces = {
			{
				name = "personal",
				path = vim.fn.expand("~/obsidian-vault"),
			},
		},
		picker = {
			name = "telescope.nvim",
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
		},
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
	},
}
