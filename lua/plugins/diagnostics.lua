return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			options = {
				-- show the diagnostic inline on every line, not only the cursor line
				multilines = {
					enabled = true,
					always_show = true,
				},
			},
		},
	},
}
