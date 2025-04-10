return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = {
            char = "┊", -- Puedes cambiar a "┊", "┆", "┇", etc.
        },
        scope = {
            enabled = true,
            show_start = true,
            show_end = false,
        },
    },
}
