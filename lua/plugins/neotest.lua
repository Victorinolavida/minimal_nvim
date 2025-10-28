function clean_cache()
	vim.fn.system("go clean -testcache")
	vim.notify("cleaning go test cache", vim.log.levels.INFO)
end
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			{
				"nvim-treesitter/nvim-treesitter", -- Optional, but recommended
				branch = "main", -- NOTE; not the master branch!
				build = function()
					vim.cmd(":TSUpdate go")
				end,
			},
			{
				"fredrikaverpil/neotest-golang",
				version = "*", -- Optional, but recommended; track releases
				build = function()
					vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
				end,
			},
		},
		config = function()
			local neotest = require("neotest")
			local config = {
				runner = "gotestsum",
			}

			neotest.setup({
				adapters = {
					require("neotest-golang")(config),
				},
				diagnostic = {
					enabled = true,
				},
			})

			-- Keybindings for running tests
			vim.keymap.set("n", "<leader>nt", function()
				clean_cache()
				neotest.run.run(vim.fn.getcwd()) -- Run all tests in project
				vim.notify("runing test", vim.log.levels.INFO)
			end, { desc = "Run all tests in project" })

			vim.keymap.set("n", "<leader>nf", function()
				neotest.run.run(vim.fn.expand("%")) -- Run tests in current file
			end, { desc = "Run tests in current file" })
			-- Error/output viewing keybindings
			vim.keymap.set("n", "<leader>no", function()
				neotest.output.open({ enter = true, auto_close = true })
			end, { desc = "Open test output" })

			vim.keymap.set("n", "<leader>nn", function()
				clean_cache()
				neotest.run.run() -- Run nearest test
				vim.notify("runnig nearest test")
			end, { desc = "Run nearest test" })

			-- Cache clearing keybindings
			vim.keymap.set("n", "<leader>nc", function()
				-- Clear cache and run all tests fresh
				for _, adapter in pairs(neotest.run.adapters()) do
					if adapter.clear_cache then
						adapter.clear_cache()
					end
				end
				-- Also clear neotest's internal cache
				vim.notify("Test cache cleared!", vim.log.levels.INFO)
			end, { desc = "Clear test cache" })

			vim.keymap.set("n", "<leader>ns", function()
				-- Check if summary is open
				local summary_open = false
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local buf_name = vim.api.nvim_buf_get_name(buf)
					if string.match(buf_name, "neotest%-summary") then
						summary_open = true
						break
					end
				end

				-- If summary is open and it's the last window, open a new buffer first
				if summary_open and #vim.api.nvim_list_wins() == 1 then
					vim.cmd("enew") -- Create a new empty buffer
				end

				neotest.summary.toggle()
			end, { desc = "Toggle test summary" })
		end,
	},
}
