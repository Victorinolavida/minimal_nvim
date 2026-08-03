return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			-- "wave" (default dark), "dragon" (darker), "lotus" (light)
			theme = "wave",
			commentStyle = { italic = true },
			keywordStyle = { italic = true },
		})
		vim.cmd.colorscheme("kanagawa")
	end,
}
