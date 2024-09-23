return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            enabled = true,
            -- keymap = {
            --     accept = "<CR>",
            --     refresh = "gr",
            -- },
            suggestion = {
                enabled = true
            }

        })
    end,

}
