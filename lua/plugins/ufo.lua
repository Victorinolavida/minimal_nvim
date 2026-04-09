-- Keymaps:
-- K        Peek fold content (falls back to LSP hover if not on a fold)
-- zR       Open all folds
-- zM       Close all folds
-- za       Toggle fold under cursor (built-in)

return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPost",
	config = function()
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup({
			provider_selector = function(_, filetype, _)
				local lsp_ft = { "go", "typescript", "javascript", "typescriptreact", "javascriptreact", "python", "rust", "lua" }
				if vim.tbl_contains(lsp_ft, filetype) then
					return { "lsp", "treesitter" }
				end
				return { "treesitter", "indent" }
			end,
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end, { desc = "Peek fold or hover" })
	end,
}
