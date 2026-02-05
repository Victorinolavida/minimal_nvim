return {
	"victorinolavida/neovim-project",
	branch = "feature/depth-based-project-discovery",
	opts = {
		projects = { -- define project roots
			{ path = "~/Documents/", depth = 4 },
		},
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
		{ "Shatur/neovim-session-manager" },
	},
	-- config = function()
	-- 	vim.keymap.set("n", "<leader>pf", function()
	-- 		vim.cmd("NeovimProjectDiscover")
	-- 	end, {
	-- 		desc = "[P]roject [F]ind",
	-- 	})
	-- end,
	lazy = false,
	priority = 100,
}
