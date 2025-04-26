return {

	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)

		-- Override default vim.notify
		vim.notify = notify

		-- Set notify as the default handler for LSP
		require("lspconfig.ui.windows").default_options = {
			border = "rounded",
			relative = "cursor",
			style = "minimal",
			zindex = 50,
			top_down = true,
			focusable = false,
			anchor = "SW",
			row = 0,
			width = 50,
			timeout = 300,
			col = 1,
			compact = true,
			position = "top",
		}

		-- notificcation center
		vim.keymap.set("n", "<leader>n", function()
			notify.dismiss({ silent = true })
		end, {
			desc = "Dismiss all notifications",
		})
		-- notification center
		vim.keymap.set("n", "<leader>nc", function()
			vim.cmd("Notifications")
		end, {
			desc = "Notification Center",
		})
	end,
	-- Optional: Customize the appearance of the notifications
	--
}
