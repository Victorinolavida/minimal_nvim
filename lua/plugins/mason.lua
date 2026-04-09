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
			"ruff",
			"tailwindcss",
			"ts_ls",
			"jdtls",
			"yamlls",
		},
		-- tailwindcss, yamlls, and jdtls are heavy/situational — enable manually per project
		automatic_enable = {
			exclude = { "tailwindcss", "yamlls", "jdtls" },
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
