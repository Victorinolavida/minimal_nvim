return {
    {
        "folke/trouble.nvim",
        -- config = function()
        --     require("trouble").setup({
        --         icons = false,
        --     })
        --
        --     vim.keymap.set("n", "<leader>tt", function()
        --         require("trouble").toggle()
        --     end)
        --
        --     vim.keymap.set("n", "[t", function()
        --         require("trouble").next({skip_groups = true, jump = true});
        --     end)
        --
        --     vim.keymap.set("n", "]t", function()
        --         require("trouble").previous({skip_groups = true, jump = true});
        --     end)
        --
        -- end
        --
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        }
    }
}
