local parsers = {
	"vimdoc",
	"javascript",
	"typescript",
	"c",
	"lua",
	"rust",
	"jsdoc",
	"bash",
	"go",
	"python",
	"tsx",
	"yaml",
	"terraform",
	"hcl",
	"java",
	"markdown",
	"markdown_inline",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	priority = 1000,
	lazy = false,
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter.setup", {}),
			callback = function(args)
				local buf = args.buf
				local filetype = args.match

				-- skip treesitter for files > 1MB
				if vim.fn.getfsize(vim.api.nvim_buf_get_name(buf)) > 1024 * 1024 then
					return
				end

				-- you need some mechanism to avoid running on buffers that do not
				-- correspond to a language (like oil.nvim buffers), this implementation
				-- checks if a parser exists for the current language
				local language = vim.treesitter.language.get_lang(filetype) or filetype
				if not vim.treesitter.language.add(language) then
					return
				end

				-- replicate `fold = { enable = true }` (this replaces nvim-ufo;
				-- foldlevel/foldenable live in config/set.lua)
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

				-- replicate `highlight = { enable = true }`
				vim.treesitter.start(buf, language)

				-- replicate `indent = { enable = true }`
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				-- `incremental_selection = { enable = true }` cannot be easily replicated
			end,
		})
	end,
}
