require("config.lazy")
require("config.set")
require("config.remap")

local autogroup = vim.api.nvim_create_augroup("config", {})
local autocmd = vim.api.nvim_create_autocmd
-- config colorscheme
vim.cmd("colorscheme gruvbox")

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
    command = 'silent! EsLintFixAll',
    group = vim.api.nvim_create_augroup('eslint', {})
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.go' },
    command = 'silent! GoFmt',
    group = vim.api.nvim_create_augroup('gofmt', {})
})
autocmd('LspAttach', {
    group = autogroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
