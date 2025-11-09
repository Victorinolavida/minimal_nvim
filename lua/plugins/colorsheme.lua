-- return {
-- Define your helper function
function ColorMyPencils(color)
	color = color or "catppuccin" -- Default to catppuccin now
	vim.cmd.colorscheme(color)

	-- Optional: transparency override
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	-- Tokyonight theme
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				transparent = true,
				terminal_colors = true,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					sidebars = "dark",
					floats = "dark",
				},
			})
		end,
	},

	-- Rose Pine theme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		lazy = false,
		config = function()
			require("rose-pine").setup({
				disable_background = true,
			})
			-- Do NOT apply rose-pine by default
		end,
	},

	-- Catppuccin theme (new default)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 2000,
		config = function()
			require("catppuccin").setup({
				flavor = "frappe",
				transparent_background = true, -- optional, depends if you want transparency
			})

			-- Apply catppuccin using your helper
			ColorMyPencils("catppuccin")
		end,
	},
	-- kanagawa theme
	{

		"rebelot/kanagawa.nvim",
		-- "ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 2000,
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})
			-- vim.cmd("colorscheme kanagawa")
			-- vim.cmd("colorscheme kanagawa-dragon")
		end, -- Default options:
	},
}
