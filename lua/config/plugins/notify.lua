return {

	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
		local notify = require("notify")
		notify.setup({
			-- background = "#0000000",
			background_colour = "#000000",
			minimum_width = 10,
			maximum_width = 80,
			top_down = false,
		})

		-- Override default vim.notify
		vim.notify = notify

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
}
