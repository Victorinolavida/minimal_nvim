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

		local function sync_vault(direction)
			local cmd = direction == "pull"
				and string.format("git -C %s pull --rebase origin main", vault)
				or string.format(
					"git -C %s add -A && git -C %s commit -m 'nvim: manual sync' && git -C %s push",
					vault, vault, vault
				)
			vim.fn.jobstart(cmd, {
				on_exit = function(_, code)
					if code == 0 then
						vim.notify("vault " .. direction .. " done", vim.log.levels.INFO)
					else
						vim.notify("vault " .. direction .. " failed", vim.log.levels.WARN)
					end
				end,
			})
		end

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
