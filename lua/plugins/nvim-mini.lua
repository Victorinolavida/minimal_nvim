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
		config = function()
			local MiniSnippets = require("mini.snippets")
			MiniSnippets.setup({
				snippets = {
					MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
				},
			})
			MiniSnippets.start_lsp_server({ match = false })
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
			-- mini files ----
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>",
					go_in_plus = "L",
					go_out = "_",
					go_out_plus = "H",
				},
			})
			vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
			vim.keymap.set("n", "<leader>-", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
			end, { desc = "Open explorer at current file" })
		end,
	},
	{
		"nvim-mini/mini.ai",
		dependencies = { "nvim-mini/mini.extra" },
		config = function()
			local MiniExtra = require("mini.extra")
			require("mini.ai").setup({
				custom_textobjects = {
					-- treesitter-based: `af`/`if` for functions, `aC`/`iC` for classes
					f = MiniExtra.gen_ai_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					C = MiniExtra.gen_ai_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
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
