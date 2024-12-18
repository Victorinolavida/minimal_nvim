return {
    {
        "tpope/vim-fugitive",

    },
    {

        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
            vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { noremap = true, silent = true, desc = "Git Diff" })
            vim.keymap.set("n", "<leader>gD", ":Gitsigns diffthis<CR>", { noremap = true, silent = true, desc = "Git Diff This" })

            vim.keymap.set("n", "<leader>gl", ":Glog<CR>", { noremap = true, silent = true, desc = "Git Log" })

            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commit" })
            --
            -- vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commit" })
            -- vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git Push" })
            -- vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { noremap = true, silent = true, desc = "Git Pull" })
            --
            -- vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true, desc = "Git Blame" })
            -- vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { noremap = true, silent = true, desc = "Git Write" })
            -- vim.keymap.set("n", "<leader>ga", ":Git add <CR>", { noremap = true, silent = true, desc = "Git Add" })
            -- vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>", { noremap = true, silent = true, desc = "Git Status" })
            -- vim.keymap.set("n", "<leader>gl", ":Glog<CR>", { noremap = true, silent = true, desc = "Git Log" })
            -- vim.keymap.set("n", "<leader>gcl", ":Git clone<CR>", { noremap = true, silent = true, desc = "Git Clone" })
            -- vim.keymap.set("n", "<leader>gn", ":Git clean", { noremap = true, silent = true, desc = "Git Clean" })
        end
    }
}
