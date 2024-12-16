return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require('telescope').setup({

            defaults = {
                ignore_patterns = {
                    "node_modules", --ignore node_modules
                },
            }
        })

        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>sf', builtin.find_files, {desc="[s]earch [f]ile"})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {desc="find git files"})
        vim.keymap.set('n', '<leader>sws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc = "find files with word under cursor"})

        vim.keymap.set('n', '<leader>sWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, {desc = "find files with word under cursor"})

        vim.keymap.set('n', '<leader>sr', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, {desc = "find files with grep"})

        vim.keymap.set('n', '<leader>ht', builtin.help_tags, {desc="Help Tags"})
        vim.keymap.set('n', '<leader>ff', ":Telescope find_files find_command=rg,--files,--hidden,--no-ignore-vcs,--no-ignore,--follow,--glob,!.git,--glob,!node_modules,--glob,!tmp,--glob,!build<CR>", {desc = "Find Files"})
        vim.keymap.set('n', '<leader>lg', function()

            builtin.live_grep({
                -- prompt_title = "Live Grep",
                -- search = vim.fn.input("Grep > "),
                -- only_sort_text = true,
                -- layout_strategy = "vertical",
                -- layout_config = {
                --     width = 0.9,
                --     height = 0.9,
                -- },
            })
        end, {desc = "Live Grep"})
    end
}
