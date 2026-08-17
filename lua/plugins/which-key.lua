return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern", -- or "classic" / "helix"
        delay = 200,
    },
    keys = {
        {
            "<leader>pk",
            function() require("which-key").show({ global = false }) end,
            desc = "Buffer Local Keymaps",
        },
    },
}
