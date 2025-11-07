return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<C-t>]], -- ✅ Usa Ctrl + t
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			direction = "horizontal", -- Puedes cambiar a "float", "vertical", etc.
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		-- Opcional: terminal flotante con <leader>tf
		local Terminal = require("toggleterm.terminal").Terminal
		local float_term = Terminal:new({ direction = "float", hidden = true })

		vim.keymap.set("n", "<leader>tf", function()
			float_term:toggle()
		end, { desc = "Toggle floating terminal" })

		-- Opcional: terminal horizontal con <leader>th
		vim.keymap.set(
			"n",
			"<leader>th",
			"<cmd>ToggleTerm direction=horizontal<CR>",
			{ desc = "Toggle horizontal terminal" }
		)
		vim.keymap.set("t", "<C-t>", [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true })
	end,
}
