return {
	"stevearc/oil.nvim",
	opts = {},
	-- dependencies = {
	-- 	"nvim-tree/nvim-web-devicons",
	-- },
	config = function()
		require("oil").setup({
			-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
			-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
			default_file_explorer = false,
			-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
			skip_confirm_for_simple_edits = true,
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			sort = {
				-- sort order can be "asc" or "desc"
				-- see :help oil-columns to see which columns are sortable
				{ "type", "asc" },
				{ "name", "asc" },
			},
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
				highlight = false,
			},
		})
		vim.keymap.set("n", "<leader>o", require("oil").open, { desc = "Open parent directory" })
	end,
}
