return {
	"saghen/blink.nvim",
	build = "cargo build --release", -- for delimiters
	keys = {
		-- chartoggle
		{
			"<C-;>",
			function()
				require("blink.chartoggle").toggle_char_eol(";")
			end,
			mode = { "n", "v" },
			desc = "Toggle ; at eol",
		},
		{
			",",
			function()
				require("blink.chartoggle").toggle_char_eol(",")
			end,
			mode = { "n", "v" },
			desc = "Toggle , at eol",
		},
	},
	-- all modules handle lazy loading internally
	lazy = false,
	opts = {
		chartoggle = { enabled = true },
		tree = { enabled = true },
	},
}
