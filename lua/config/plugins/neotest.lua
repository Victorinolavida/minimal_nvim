return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			{
				"fredrikaverpil/neotest-golang",
				version = "*", -- Optional, but recommended; track releases
				build = function()
					vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
				end,
			},
		},
		keys = {
			{
				"<leader>bs",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle test summary",
			},
			{
				"<leader>br",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>bS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop nearest test",
			},
			{
				"<leader>bR",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run all tests in current file",
			},
			{
				"<leader>bA",
				function()
					require("neotest").run.run({ suite = true })
				end,
				desc = "Run the whole test suite",
			},
			{
				"<leader>bO",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Open test output",
			},
			{
				"<leader>bL",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle test output panel",
			},
		},
		config = function()
			local config = {
				runner = "go",
				go_test_args = {
					"-v",
					"./...",
				},
				-- Set the root directory pattern

				root_pattern = { "go.mod", "go.work", ".git" },
				-- Set working directory to project root
				experimental = {
					test_table = true,
				},
				discovery = {
					enabled = true,
					concurrent = 1,
				},
			}
			require("neotest").setup({
				adapters = {
					require("neotest-golang")(config),
				},
			})
		end,
	},
}
