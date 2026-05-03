return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "Avante" },
	opts = {
		render_modes = { "n", "c", "t" },
		heading = {
			sign = false,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		bullet = {
			icons = { "•", "◦", "▸", "▹" },
		},
		checkbox = {
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		pipe_table = { preset = "round" },
	},
	keys = {
		{ "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Markdown Preview Toggle" },
	},
}
