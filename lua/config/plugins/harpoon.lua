return {
    'ThePrimeagen/harpoon',
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        -- REQUIRED
        harpoon:setup()
        -- REQUIRED
        vim.keymap.set("n", "<leader>ba", function() harpoon:list():add() end, { desc = "[A]dd [B]uffer" })
        vim.keymap.set("n", "<leader>bm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "[B]uffer [M]enu" })
        vim.keymap.set("n", "<leader>bp", function() harpoon:list():prev() end, { desc = "[B]uffer [P]revius" })
        vim.keymap.set("n", "<leader>bn", function() harpoon:list():next() end, { desc = "[B]uffer [N]ext" })

        for i = 1, 5 do
            local commandSelect = string.format("<leader>b%d", i)
            local commandReplace = string.format("<leader>br%d", i)
            -- Go to buffer 1
            vim.keymap.set("n", commandSelect, function()
                harpoon:list():select(i)
            end, { desc = string.format("Select [B]uffer %d", i) })
            -- replace buffer i
            vim.keymap.set("n", commandReplace, function()
                harpoon:list():replace_at(i)
            end, { desc = string.format("[R]eplace [B]uffer %d", i) })
        end
    end
}
