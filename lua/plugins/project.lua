return {
	"victorinolavida/neovim-project",
	branch = "feature/depth-based-project-discovery",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
		{ "Shatur/neovim-session-manager" },
	},
	lazy = false,
	priority = 100,
	opts = {
		projects = {
			{ path = "~/Documents/", depth = 2 },
		},
	},
	config = function(_, opts)
		require("neovim-project").setup(opts)
		vim.keymap.set("n", "<leader>pf", "<cmd>NeovimProjectDiscover<CR>", { desc = "[P]roject [F]ind" })
		vim.keymap.set("n", "<leader>ph", "<cmd>NeovimProjectHistory<CR>", { desc = "[P]roject [H]istory" })
	end,
}
