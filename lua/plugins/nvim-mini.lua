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
		config = function()
			local MiniDiff = require("mini.diff")
			MiniDiff.setup({
				source = MiniDiff.gen_source.git(),
			})
			-- Full-screen git UI (was `:Git` in a new tab via fugitive).
			vim.keymap.set("n", "<leader>gg", function()
				Snacks.lazygit()
			end, { desc = "Git (lazygit)" })
			-- Inline diff of the working tree against the index, in-buffer
			-- (was `:Gvdiffsplit`). Toggle again to hide.
			vim.keymap.set("n", "<leader>gd", MiniDiff.toggle_overlay, { desc = "Git diff overlay" })
		end,
	},
	{
		"nvim-mini/mini.ai",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
}
