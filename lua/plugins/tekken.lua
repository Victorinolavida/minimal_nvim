return {
	"soon2moon/tekken.nvim",
	cmd = { "TekkenToggle", "TekkenNext", "TekkenPrev", "TekkenSync" },
	keys = {
		{ "<leader>m", "<cmd>TekkenToggle<cr>", desc = "Tekken: local marks menu" },
		{ "]m", "<cmd>TekkenNext<cr>", desc = "Tekken: next local mark" },
		{ "[m", "<cmd>TekkenPrev<cr>", desc = "Tekken: prev local mark" },
	},
	opts = {
		order = "added",
		border = "rounded",
		preview_context = 10,
	},
}
