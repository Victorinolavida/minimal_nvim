return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        local oil = require("oil")
        oil.setup {
            -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            columns = { "icon" },
            view_options = {
                show_hidden = true,
                highlight = false,
            },
        }
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory (oil)" })
        vim.keymap.set("n", "<leader>-", oil.toggle_float, { desc = "Open parent directory (oil, float)" })
    end
}
