return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"eslint",
			"golangci_lint_ls",
			"gopls",
			"pyright",
			"tailwindcss",
			"ts_ls",
			"jdtls",
			"yamlls",
			"dockerls",
			"docker_compose_language_service",
		},
		-- tailwindcss and jdtls are heavy/situational — enable manually per project.
		-- stylua is a formatter, but lspconfig ships an lsp/stylua.lua (`stylua --lsp`),
		-- so installing it for conform also auto-attached it as a second Lua client.
		automatic_enable = {
			exclude = { "tailwindcss", "jdtls", "stylua" },
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		-- Auto-install formatters/linters used by conform (not LSP servers).
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
}
