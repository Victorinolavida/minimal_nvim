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
                if not c then return end
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
    end,
}
