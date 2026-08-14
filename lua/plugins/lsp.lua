return {
	{
		"neovim/nvim-lspconfig",
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mason-org/mason.nvim",
		},
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
		config = function(_, opts)
			-- Defining `config` overrides lazy.nvim's default `setup(opts)` call, so the
			-- opts above (ensure_installed / automatic_enable) only take effect because
			-- we pass them through here. Without this nothing calls vim.lsp.enable() and
			-- no server ever attaches.
			require("mason-lspconfig").setup(opts)

			local autogroup = vim.api.nvim_create_augroup("lsp_config", {})
			local autocmd = vim.api.nvim_create_autocmd

			-- Diagnostic signs in the gutter (aside the line number) + underline in the buffer
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "",
					},
					-- colour the line number itself (not just the sign) per severity
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
						[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
						[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					},
				},
				underline = true,
				severity_sort = true,
				virtual_text = false, -- handled by tiny-inline-diagnostic.nvim
			})

			autocmd("LspAttach", {
				group = autogroup,
				callback = function(e)
					if vim.fn.getfsize(vim.api.nvim_buf_get_name(e.buf)) > 1024 * 1024 then
						vim.lsp.buf_detach_client(e.buf, e.data.client_id)
						return
					end

					local opts = { buffer = e.buf, silent = true, noremap = true }
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
					end

					map("n", "gd", vim.lsp.buf.definition, "Go to definition")
					map("n", "gr", vim.lsp.buf.references, "Go to references")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
					map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
					map("n", "<leader>wd", vim.diagnostic.open_float, "Open diagnostics")
					map("n", "<leader>wa", vim.lsp.buf.code_action, "Code actions")
					map("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "List workspace folders")
					map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					-- Route through conform so manual formatting matches format-on-save
					-- (plain vim.lsp.buf.format would use lua_ls instead of stylua, etc.).
					map("n", "<leader>F", function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end, "Format buffer")
					map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

					-- move between diagnostics ([prev, ]next is the convention)
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Previous diagnostic")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Next diagnostic")

					-- inlay hints toggle
					map("n", "<leader>lh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = e.buf }))
					end, "Toggle inlay hints")

					-- LSP control
					map("n", "<leader>lq", ":LspStop<CR>", "LSP stop")
					map("n", "<leader>lr", ":LspRestart<CR>", "LSP restart")
					map("n", "<leader>li", ":LspInfo<CR>", "LSP info")
				end,
			})
		end,
	},
}
