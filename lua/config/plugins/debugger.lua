return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("dap-go").setup()
		require("dapui").setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<leader>dc", dap.continue, {})
	end,
	-- {
	--     "mfussenegger/nvim-dap",
	--     dependencies = {
	--         "rcarriga/nvim-dap-ui",
	--         "leoluz/nvim-dap-go",
	--         "nvim-neotest/nvim-nio",
	--     },
	--
	--     config = function()
	--         local dap, dapui = require("dap"), require("dapui")
	--
	--         require("dapui").setup()
	--         require("dap-go").setup()
	--
	--         dap.listeners.before.attach.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.launch.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.event_terminated.dapui_config = function()
	--             dapui.close()
	--         end
	--         dap.listeners.before.event_exited.dapui_config = function()
	--             dapui.close()
	--         end
	--
	--         vim.keymap.set("n", "<Leader>dt", ":DapUiToggle<CR>", {})
	--         vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
	--         vim.keymap.set("n", "<Leader>dc", dap.continue, {})
	--         vim.keymap.set("n", "<Leader>dr", ":lua require('dapui').open({reset = true})<CR>", {})
	--
	--         vim.fn.sign_define(
	--             "DapBreakpoint",
	--             { text = "⏺", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	--         )
	--     end,
	-- },
	-- {
	--     "mfussenegger/nvim-dap-python",
	--     ft = "python",
	--     dependencies = {
	--         "mfussenegger/nvim-dap",
	--     },
	--     config = function()
	--         local dap, dapui = require("dap"), require("dapui")
	--
	--         require("dapui").setup()
	--
	--         dap.listeners.before.attach.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.launch.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.event_terminated.dapui_config = function()
	--             dapui.close()
	--         end
	--         dap.listeners.before.event_exited.dapui_config = function()
	--             dapui.close()
	--         end
	--
	--         local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
	--         require("dap-python").setup(path)
	--     end,
	-- },
}
