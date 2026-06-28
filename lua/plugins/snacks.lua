return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<C-t>",
			function()
				Snacks.terminal(nil, { win = { position = "bottom" } })
			end,
			mode = { "n", "t" },
			desc = "Toggle terminal",
		},
		{
			"<leader>tf",
			function()
				Snacks.terminal(nil, { win = { position = "float" } })
			end,
			desc = "Toggle floating terminal",
		},
		{
			"<leader>th",
			function()
				Snacks.terminal(nil, { win = { position = "bottom" } })
			end,
			desc = "Toggle horizontal terminal",
		},
	},
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		indent = { enabled = true, indent = { char = "┊" } },
		notifier = { enabled = true },
		lazygit = { enabled = true },
		terminal = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		image = { enabled = false },
		zen = { enabled = true },
		dim = { enabled = false },
		scope = { enabled = true },
	},
}
