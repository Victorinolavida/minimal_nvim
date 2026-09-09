return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim", config = true },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- LSP LUA
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()
        require("mason-tool-installer").setup({
            ensure_installed = { "gopls", "gofumpt", "goimports", "golangci-lint", "delve", "lua_ls",
                "rust_analyzer",
                "eslint",
                "golangci_lint_ls",
                "pyright",
                "tailwindcss",
                "clangd",
                "ts_ls",
                "jdtls",
                "yamlls",
                "dockerls",
                "docker_compose_language_service",
            },
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
        vim.lsp.config("*", { capabilities = capabilities })

        vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { desc = "Format Local buffer" })
        vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

        vim.diagnostic.config({ virtual_text = true })

        local grp = vim.api.nvim_create_augroup("lsp_autocmd_format", { clear = true })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = grp,
            callback = function(args)
                local c = vim.lsp.get_client_by_id(args.data.client_id)
                if not c then
                    return
                end

                if not c:supports_method("textDocument/formatting") then
                    return
                end
                -- Format the current buffer on save

                vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
                    end,
                })
            end,
        })


        -- float showing the diagnostic under cursor
        -- vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
        --
        -- -- jump between diagnostics
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next Diagnostic" })
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev Diagnostic" })
        --
        -- -- populate the location/quickfix list
        -- vim.keymap.set("n", "<leader>xd", vim.diagnostic.setloclist, { desc = "Diagnostics (loclist)" })
        local autocmd = vim.api.nvim_create_autocmd
        local autogroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

        autocmd("LspAttach", {
            group = autogroup,
            callback = function(e)
                local opts = { buffer = e.buf, silent = true, noremap = true }

                vim.keymap.set("n", "gd", function()
                    vim.lsp.buf.definition()
                end, { unpack(opts), desc = "Go to definition" })

                vim.keymap.set("n", "gr", function()
                    vim.lsp.buf.references()
                end, { unpack(opts), desc = "Go to references" })

                vim.keymap.set("n", "gD", function()
                    vim.lsp.buf.declaration()
                end, { unpack(opts), desc = "Go to declaration" })

                vim.keymap.set("n", "gi", function()
                    vim.lsp.buf.implementation()
                end, { unpack(opts), desc = "Go to implementation" })

                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover()
                end, { unpack(opts), desc = "Show hover" })

                vim.keymap.set("n", "<leader>ws", function()
                    vim.lsp.buf.workspace_symbol()
                end, { unpack(opts), desc = "Workspace symbols" })

                vim.keymap.set("n", "<leader>wd", function()
                    vim.diagnostic.open_float()
                end, { unpack(opts), desc = "Open diagnostics" })

                vim.keymap.set("n", "<leader>wa", function()
                    vim.lsp.buf.code_action()
                end, { unpack(opts), desc = "Workspace actions" })

                vim.keymap.set("n", "<leader>wr", function()
                    vim.lsp.buf.references()
                end, { unpack(opts), desc = "Workspace references" })

                vim.keymap.set("n", "<leader>rn", function()
                    vim.lsp.buf.rename()
                end, { unpack(opts), desc = "Rename" })

                vim.keymap.set("i", "<C-s>", function()
                    vim.lsp.buf.signature_help()
                end, { unpack(opts), desc = "Signature help" })

                vim.keymap.set("n", "<leader>D", function()
                    vim.lsp.buf.type_definition()
                end, { unpack(opts), desc = "Type definition" })

                -- Diagnostics navigation (0.11+/0.12: goto_next/goto_prev are deprecated,
                -- use vim.diagnostic.jump instead; float=true preserves old auto-popup behavior)
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, { unpack(opts), desc = "Previous diagnostic" })

                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, { unpack(opts), desc = "Next diagnostic" })

                -- Quickfix list navigation
                vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz", opts)

                vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz", opts)
            end,
        })

        vim.lsp.handlers["$/progress"] = function() end
    end,
}
