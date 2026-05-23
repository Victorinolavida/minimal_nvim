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

			dap.configurations.go = {
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
			}

			-- breakpoints
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ebug toggle [b]reakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "[d]ebug conditional [B]reakpoint" })
			vim.keymap.set("n", "<leader>dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
			end, { desc = "[d]ebug [l]og point" })

			-- execution
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ebug [c]ontinue" })
			vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "[d]ebug [s]tep over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ebug step [i]nto" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[d]ebug step [o]ut" })
			vim.keymap.set("n", "<leader>dR", dap.restart, { desc = "[d]ebug [R]estart" })
			vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "[d]ebug [r]un last" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "[d]ebug [q]uit" })

			-- ui
			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end, { desc = "[d]ebug [u]i toggle" })

			-- go-specific
			vim.keymap.set("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "[d]ebug go [t]est" })
			vim.keymap.set("n", "<leader>dT", function()
				require("dap-go").debug_last_test()
			end, { desc = "[d]ebug go last [T]est" })
		end,
	},
}
