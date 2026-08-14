-- Format-on-save.
--
-- Self-contained: conform runs the formatters, and mason-tool-installer makes
-- sure the binaries they shell out to actually exist. Loaded eagerly (no
-- event/ft/keys) on purpose — mason-tool-installer only kicks off its install
-- run on VimEnter, so lazy-loading conform behind BufWritePre would mean the
-- tools never get installed until something else happened to pull it in.
return {
	"stevearc/conform.nvim",
	dependencies = {
		-- mason.nvim is what prepends its bin/ to $PATH, so conform can find
		-- stylua/gofumpt/prettierd/... without them being installed globally.
		-- It is also configured in lua/plugins/lsp.lua; lazy.nvim merges the
		-- two specs, this entry only pins the load order.
		{ "mason-org/mason.nvim", opts = {} },
		-- Auto-install the formatters below (mason-lspconfig only handles LSP
		-- servers, not formatters/linters).
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = {
					"stylua", -- lua
					"gofumpt", -- go
					"goimports", -- go
					"golines", -- go
					"misspell", -- generic spell-check formatter
					"prettier", -- web (css/html/json/yaml/md/...)
					"prettierd", -- web (js/ts)
					"ruff", -- python (lints + formats; Mason installs it into its own venv)
				},
			},
		},
	},
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
			-- Runs on every :write. `lsp_format = "fallback"` means: if the
			-- filetype has no formatter configured below, ask the attached LSP
			-- client instead, and if there is none either, do nothing.
			format_on_save = function(bufnr)
				-- Escape hatch: `:let b:disable_autoformat = 1` for one buffer,
				-- or `:let g:disable_autoformat = 1` for the session.
				if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
					return
				end
				return {
					lsp_format = "fallback",
					timeout_ms = 1500,
				}
			end,
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
