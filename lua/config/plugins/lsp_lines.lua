return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	config = function()
		require("lsp_lines").setup({})
		vim.diagnostic.config({
			virtual_text = false, -- removes duplication of diagnostic messages due to lsp_lines
			virtual_lines = true,
		})
	end,
}
