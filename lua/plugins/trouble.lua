return {
    "folke/trouble.nvim",
    opts = {},
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
        { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols" },
    },
}
