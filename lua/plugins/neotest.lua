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
		local neotest = require("neotest")
		-- local wk = require("which-key")

		neotest.setup({
			adapters = {
				require("neotest-go")({
					args = { "-v", "-count=1" },
				}),
			},
		})

		-- register <leader>n as a named group so which-key shows it
		-- wk.add({ { "<leader>n", group = "Neotest" } })

		vim.keymap.set("n", "<leader>nt", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })

		vim.keymap.set("n", "<leader>nd", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })

		vim.keymap.set("n", "<leader>nf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run file" })

		vim.keymap.set("n", "<leader>na", function()
			neotest.run.run({ suite = true })
		end, { desc = "Run all" })

		vim.keymap.set("n", "<leader>ns", function()
			neotest.run.stop()
		end, { desc = "Stop" })

		vim.keymap.set("n", "<leader>no", function()
			neotest.output.open({ enter = true })
		end, { desc = "Output (nearest)" })

		vim.keymap.set("n", "<leader>nO", function()
			neotest.output_panel.toggle()
		end, { desc = "Output panel" })

		vim.keymap.set("n", "<leader>nS", function()
			neotest.summary.toggle()
		end, { desc = "Summary" })

		vim.keymap.set("n", "]n", function()
			neotest.jump.next({ status = "failed" })
		end, { desc = "Next failed test" })

		vim.keymap.set("n", "[n", function()
			neotest.jump.prev({ status = "failed" })
		end, { desc = "Prev failed test" })
	end,
}
