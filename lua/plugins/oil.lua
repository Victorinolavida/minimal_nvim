-- <CR>       Open entry            g?  Show all oil mappings
return {
	"stevearc/oil.nvim",
	lazy = false,
	config = function()
		local oil = require("oil")

		oil.setup({
			-- netrw is disabled in config/set.lua, so oil must handle `nvim .`
			-- and `:e src/` or those buffers come up empty.
			default_file_explorer = true,
			skip_confirm_for_simple_edits = true,
			columns = { "icon" },
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
			view_options = {
				show_hidden = true,
				highlight = false,
			},
		})

		-- `-` opens the parent dir of the current file with the cursor on it,
		-- matching the mini.files binding this replaces.
		vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory (oil)" })
		vim.keymap.set("n", "<leader>-", oil.toggle_float, { desc = "Open parent directory (oil, float)" })
	end,
}
