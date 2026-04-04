return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				config = function()
					local dapui = require("dapui")
					dapui.setup()
					local dap = require("dap")
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},
			{
				"leoluz/nvim-dap-go",
				config = function()
					require("dap-go").setup()
				end,
			},
		},
		config = function()
			local dap = require("dap")
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ebug toggle [b]reakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ebug [c]ontinue" })
			vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "[d]ebug [s]tep over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ebug step [i]nto" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[d]ebug step [o]ut" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "[d]ebug [q]uit" })
			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end, { desc = "[d]ebug [u]i toggle" })
			vim.keymap.set("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "[d]ebug go [t]est" })
		end,
	},
}
