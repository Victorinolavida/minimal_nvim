return {
	"ahmedkhalf/project.nvim",
	config = function()
		require("project_nvim").setup({
			-- Auto-detect project root
			detection_methods = { "lsp", "pattern" },
			patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
			-- Show hidden files in telescope
			show_hidden = false,
			-- Don't calculate root dir on every BufEnter
			silent_chdir = true,
		})

		-- Enable telescope extension
		require("telescope").load_extension("projects")
		vim.keymap.set("n", "<leader>pp", "<cmd>Telescope projects<cr>")
	end,
}
