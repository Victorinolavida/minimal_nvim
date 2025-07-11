return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"j-hui/fidget.nvim",
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim",
		"sublimelsp/LSP-eslint",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local conform = require("conform")
		conform.setup({
			log_level = vim.log.levels.DEBUG,
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1500,
				stop_after_first = true,
			},
			format = {
				async = true,
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
				python = { "isort", "black" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				["_"] = { "trim_whitespace" },
			},
		})

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		local lspkind = require("lspkind")
		require("luasnip.loaders.from_vscode").lazy_load()
		cmp.setup({
			formatting = {
				format = lspkind.cmp_format({
					-- mode = "symbol", -- show only symbol annotations
					mode = "symbol_text", -- show both symbol and text annotations
					maxwidth = {
						-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- can also be a function to dynamically calculate max width such as
						-- menu = function() return math.floor(0.45 * vim.o.columns) end,
						menu = 50, -- leading text (labelDetails)
						abbr = 50, -- actual suggestion item
					},
					ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					show_labelDetails = true, -- show labelDetails in menu. Disabled by default

					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					before = function(entry, vim_item)
						-- ...
						return vim_item
					end,
				}),
			},
		})

		require("fidget").setup({})
		require("mason").setup()
		local mason_tool_installer = require("mason-tool-installer")

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				-- "rust_analyzer",
				"gopls",
				"cssls",
				"eslint",
				"jsonls",
				"css_variables",
				"tailwindcss",
				-- "prismals",
				"golangci_lint_ls",
				"html",
				"emmet_ls",
				"pyright",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
					})
				end,
				["eslint_d"] = function()
					require("lspconfig").eslint.setup({
						capabilities = capabilities,
						on_attach = function(client)
							client.server_capabilities.definitionProvider = false
						end,
					})
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								gofumpt = true,
								analyses = {
									unusedparams = true,
									unusedwriteparams = true,
									shadow = true,
									nilness = true,
								},
							},
						},
					})
				end,
			},
		})
		mason_tool_installer.setup({
			ensure_installed = {
				-- JS / TS / Web
				"prettier",
				"prettierd",
				"eslint_d",
				"eslint",
				"jsonlint",

				-- Lua
				"stylua",

				-- Go
				"gofumpt",
				"golines",
				"goimports",
				"staticcheck",
				"golangci-lint",

				-- General
				"misspell",
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
		vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
	end,
}
