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
				"theHamsta/nvim-dap-virtual-text",
				opts = {
					commented = true,
				},
			},
			{
				"leoluz/nvim-dap-go",
				config = function()
					require("dap-go").setup()
				end,
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mason-org/mason.nvim" },
				opts = {
					ensure_installed = { "delve" },
					automatic_installation = true,
				},
			},
		},
		config = function()
			local dap = require("dap")
			-- local wk = require("which-key")

			-- append extra go configs on top of what dap-go sets up
			vim.list_extend(dap.configurations.go or {}, {
				{
					type = "go",
					name = "Debug main",
					request = "launch",
					program = "${fileDirname}",
				},
				{
					type = "go",
					name = "Debug main (with args)",
					request = "launch",
					program = "${fileDirname}",
					args = function()
						local args = vim.fn.input("Args: ")
						return vim.split(args, " ")
					end,
				},
			})

			-- register <leader>D as a named group so which-key shows it
			-- wk.add({ { "<leader>D", group = "Debug" } })

			-- breakpoints
			vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>DB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "Conditional breakpoint" })
			vim.keymap.set("n", "<leader>Dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
			end, { desc = "Log point" })

			-- execution
			vim.keymap.set("n", "<leader>Dc", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<leader>Ds", dap.step_over, { desc = "Step over" })
			vim.keymap.set("n", "<leader>Di", dap.step_into, { desc = "Step into" })
			vim.keymap.set("n", "<leader>Do", dap.step_out, { desc = "Step out" })
			vim.keymap.set("n", "<leader>DR", dap.restart, { desc = "Restart" })
			vim.keymap.set("n", "<leader>Dr", dap.run_last, { desc = "Run last" })
			vim.keymap.set("n", "<leader>Dq", dap.terminate, { desc = "Quit" })

			-- ui
			vim.keymap.set("n", "<leader>Du", function()
				require("dapui").toggle()
			end, { desc = "Toggle UI" })
			vim.keymap.set({ "n", "v" }, "<leader>De", function()
				require("dapui").eval()
			end, { desc = "Eval expression" })

			-- go-specific
			vim.keymap.set("n", "<leader>Dt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug test (Go)" })
			vim.keymap.set("n", "<leader>DT", function()
				require("dap-go").debug_last_test()
			end, { desc = "Debug last test (Go)" })
		end,
	},
}
