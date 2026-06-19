return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			-- misspell is not a conform builtin, so define it ourselves.
			-- It fixes common spelling mistakes in-place.
			formatters = {
				misspell = {
					command = "misspell",
					args = { "-w", "$FILENAME" },
					stdin = false,
				},
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1500,
				stop_after_first = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt", "golines" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				["_"] = { "trim_whitespace", "misspell" },
			},
		})
	end,
}
