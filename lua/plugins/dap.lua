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
			vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, { desc = "[D]ebug toggle [b]reakpoint" })
			vim.keymap.set("n", "<leader>DB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "[D]ebug conditional [B]reakpoint" })
			vim.keymap.set("n", "<leader>Dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
			end, { desc = "[D]ebug [l]og point" })

			-- execution
			vim.keymap.set("n", "<leader>Dc", dap.continue, { desc = "[D]ebug [c]ontinue" })
			vim.keymap.set("n", "<leader>Ds", dap.step_over, { desc = "[D]ebug [s]tep over" })
			vim.keymap.set("n", "<leader>Di", dap.step_into, { desc = "[D]ebug step [i]nto" })
			vim.keymap.set("n", "<leader>Do", dap.step_out, { desc = "[D]ebug step [o]ut" })
			vim.keymap.set("n", "<leader>DR", dap.restart, { desc = "[D]ebug [R]estart" })
			vim.keymap.set("n", "<leader>Dr", dap.run_last, { desc = "[D]ebug [r]un last" })
			vim.keymap.set("n", "<leader>Dq", dap.terminate, { desc = "[D]ebug [q]uit" })

			-- ui
			vim.keymap.set("n", "<leader>Du", function()
				require("dapui").toggle()
			end, { desc = "[D]ebug [u]i toggle" })

			-- go-specific
			vim.keymap.set("n", "<leader>Dt", function()
				require("dap-go").debug_test()
			end, { desc = "[D]ebug go [t]est" })
			vim.keymap.set("n", "<leader>DT", function()
				require("dap-go").debug_last_test()
			end, { desc = "[D]ebug go last [T]est" })
		end,
	},
}
