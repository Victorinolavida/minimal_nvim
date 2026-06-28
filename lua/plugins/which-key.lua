return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		-- Give DAP mappings a group label so the popup is readable
		spec = {
			{ "<leader>D", group = "DAP" },
			{ "<leader>n", group = "Neotest" },
			{ "<leader>f", group = "Find (Telescope)" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>g", group = "Git" },
			{ "<leader>w", group = "Workspace" },
		},
	},
}
