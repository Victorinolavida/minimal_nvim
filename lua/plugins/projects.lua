return {
	"nvim-telescope/telescope-project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>fp", require("telescope").extensions.project.project, { desc = "Find Projects" })
	end,
	-- config = function()
	-- end,
}
