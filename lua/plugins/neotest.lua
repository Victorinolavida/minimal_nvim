return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-go")({
					experimental = {
						test_table = true,
					},
				}),
			},
		})

		vim.keymap.set("n", "<leader>nt", function()
			require("neotest").run.run()
		end, { desc = "[n]eotest run nearest [t]est" })

		vim.keymap.set("n", "<leader>nf", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "[n]eotest run [f]ile" })

		vim.keymap.set("n", "<leader>na", function()
			require("neotest").run.run({ suite = true })
		end, { desc = "[n]eotest run [a]ll" })

		vim.keymap.set("n", "<leader>ns", function()
			require("neotest").run.stop()
		end, { desc = "[n]eotest [s]top" })

		vim.keymap.set("n", "<leader>no", function()
			require("neotest").output_panel.toggle()
		end, { desc = "[n]eotest [o]utput panel" })

		vim.keymap.set("n", "<leader>nS", function()
			require("neotest").summary.toggle()
		end, { desc = "[n]eotest [S]ummary" })
	end,
}
