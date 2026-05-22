return {
	-- Catppuccin (active theme)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "frappe",
				transparent_background = true,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- Tokyonight (available on demand)
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "storm",
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
				sidebars = "dark",
				floats = "dark",
			},
		},
	},

	-- Rose Pine (available on demand)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {
			disable_background = true,
		},
	},

	-- Kanagawa (available on demand)
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = {
			theme = "wave",
			transparent = false,
			background = { dark = "wave", light = "lotus" },
		},
	},
}
