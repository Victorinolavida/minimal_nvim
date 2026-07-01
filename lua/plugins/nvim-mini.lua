return {
	{
		"nvim-mini/mini.surround",
		config = function()
			require("mini.surround").setup()
			-- Default Keymaps
			-- | `sa` | Add surrounding or Direct with 'saiw' |
			-- | `sd` | Delete surrounding |
			-- | `sr` | Replace surrounding |
			-- | `sf` | Find surrounding (right) |
			-- | `sF` | Find surrounding (left) |
			-- | `sh` | Highlight surrounding |
			-- | `sn` | Update n_lines |
			-- | `l` / `n` | as suffix for prev/next |
		end,
	},
	{
		"nvim-mini/mini.snippets",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local MiniSnippets = require("mini.snippets")
			MiniSnippets.setup({
				snippets = {
					MiniSnippets.gen_loader.from_lang(),
				},
			})
			-- Stop the snippet session as soon as we jump to the final tabstop ($0)
			-- so the ∎ marker doesn't linger until Escape/next edit.
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniSnippetsSessionJump",
				callback = function(args)
					if args.data.tabstop_to == "0" then
						MiniSnippets.session.stop()
					end
				end,
			})
		end,
	},
	{
		"nvim-mini/mini.pairs",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"nvim-mini/mini.diff",
		dependencies = {
			"tpope/vim-fugitive",
		},
		config = function()
			local MiniDiff = require("mini.diff")
			MiniDiff.setup({
				source = MiniDiff.gen_source.git(),
			})
			vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
			vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })
		end,
	},
	{
		"nvim-mini/mini.files",
		version = false,
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>",
					go_in_plus = "L",
					go_out = "_",
					go_out_plus = "H",
				},
			})
			vim.keymap.set("n", "-", function()
				-- open at the current file's folder (with it focused); fall back
				-- to the cwd for unnamed/non-file buffers.
				local fname = vim.api.nvim_buf_get_name(0)
				if fname ~= "" and vim.uv.fs_stat(fname) then
					MiniFiles.open(fname, false)
				else
					MiniFiles.open()
				end
			end, { desc = "Toggle mini file explorer (at current file)" })
			vim.keymap.set("n", "<leader>-", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
			end, { desc = "Open explorer at current file" })
		end,
	},
	{
		"nvim-mini/mini.ai",
		dependencies = { "nvim-mini/mini.extra", "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			local MiniAi = require("mini.ai")
			MiniAi.setup({
				custom_textobjects = {
					-- treesitter-based: `af`/`if` for functions, `aC`/`iC` for classes
					f = MiniAi.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					C = MiniAi.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				},
			})

			vim.api.nvim_create_user_command("MiniAiHelp", function()
				vim.notify(table.concat({
					"── mini.ai text objects ──────────────",
					"  f   function (treesitter)",
					"  C   class (treesitter)",
					"  a   argument / parameter",
					"  t   HTML/XML tag",
					"  b   bracket (any of [{()",
					"  q   quote (any of \"\\'`)",
					"  ?   prompt for a custom delimiter",
					"  )]} standard bracket pairs",
					"  \"'` standard quote pairs",
					"",
					"Usage: [count][a|i]<obj>  e.g. vaf, dif, ci)",
				}, "\n"), vim.log.levels.INFO, { title = "mini.ai" })
			end, { desc = "Show mini.ai text object cheatsheet" })
		end,
	},
	{
		"nvim-mini/mini.extra",
		dependencies = {
			"nvim-mini/mini.pick",
		},
		version = false,
		config = function()
			local MiniPick = require("mini.pick")
			local MiniExtra = require("mini.extra")
			MiniPick.setup()
			MiniExtra.setup()
			vim.keymap.set("n", "<leader>xx", function()
				MiniExtra.pickers.diagnostic()
			end, { desc = "Mini Picker Diagnostics" })
			vim.keymap.set("n", "<leader>pk", function()
				MiniExtra.pickers.keymaps()
			end, { desc = "Search keymaps" })
		end,
	},
}
