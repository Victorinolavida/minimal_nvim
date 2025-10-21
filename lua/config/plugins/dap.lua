return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			require("nvim-dap-virtual-text").setup({
				-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			-- Handled by nvim-dap-go
			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			-- vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			-- vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			--
			vim.keymap.set("n", "<space>dt", function()
				dap.toggle_breakpoint()
			end, {
				desc = "DAP Toggle Breakpoint",
			})
			vim.keymap.set("n", "<space>drc", function()
				dap.run_to_cursor()
			end, {
				desc = "DAP Run to Cursor",
			})
			-- Eval var under cursor
			-- vim.keymap.set("n", "<space>?", function()
			-- 	require("dapui").eval(nil, { enter = true })
			-- end)
			vim.keymap.set("n", "<space>d?", function()
				require("dapui").eval(nil, { enter = true })
			end, {
				desc = "DAP Eval under cursor",
			})

			vim.keymap.set("n", "<space>dc", dap.continue, {
				desc = "DAP Continue",
			})
			vim.keymap.set("n", "<space>di", dap.step_into, {
				desc = "DAP Step Into",
			})
			vim.keymap.set("n", "<space>do", dap.step_over, {
				desc = "DAP Step Over",
			})
			vim.keymap.set("n", "<space>dO", dap.step_out, {
				desc = "DAP Step Out",
			})

			vim.keymap.set("n", "<space>dr", dap.restart, {
				desc = "DAP Restart",
			})

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
