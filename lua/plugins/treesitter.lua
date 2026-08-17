return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter")
				.install({
					"rust",
					"javascript",
					"go",
					"python",
					"vim",
					"vimdoc",
					"yaml",
					"zsh",
					"typescript",
					"toml",
					"tsx",
					"tsv",
					"terraform",
					"sql",
					"regex",
					"html",
					"css",
					"json",
					"bash",
					"http",
					"dockerfile",
				})
				:wait(300000) -- wait max. 5 minutes    end,

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype

					local lang = vim.treesitter.language.get_lang(ft)
					if not lang then
						return
					end

					local ok_add = pcall(vim.treesitter.language.add, lang)
					if not ok_add then
						return
					end

					pcall(vim.treesitter.start, buf, lang)
				end,
			})
		end,
	},
}
