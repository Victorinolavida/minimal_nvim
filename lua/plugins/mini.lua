return {
    {
        "nvim-mini/mini.pairs",
        version = false,
        config = function()
            require('mini.pairs').setup()
        end
    },
    {
        'nvim-mini/mini.surround',
        version = false,

        config = function()
            --            mappings = {
            --   add = 'sa', -- Add surrounding in Normal and Visual modes
            --   delete = 'sd', -- Delete surrounding
            --   find = 'sf', -- Find surrounding (to the right)
            --   find_left = 'sF', -- Find surrounding (to the left)
            --   highlight = 'sh', -- Highlight surrounding
            --   replace = 'sr', -- Replace surrounding
            --
            --   suffix_last = 'l', -- Suffix to search with "prev" method
            --   suffix_next = 'n', -- Suffix to search with "next" method
            -- },
            require("mini.surround").setup()
        end
    },
    {
        'nvim-mini/mini.cmdline',
        version = false,

        config = function()
            require('mini.cmdline').setup()
        end
    },
    {
        'nvim-mini/mini.notify',
        version = false,
        config = function()
            require('mini.notify').setup()
        end
    },
    {
        'nvim-mini/mini.tabline',
        version = false,
        config = function()
            require('mini.tabline').setup()
        end
    },
    {
        'nvim-mini/mini.indentscope',
        version = false,

        config = function()
            require('mini.indentscope').setup()
        end
    },
    {
        'nvim-mini/mini.hipatterns',
        version = false,
        config = function()
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end
    },
    {
        'nvim-mini/mini.cursorword',
        version = false,
        config = function()
            require('mini.cursorword').setup()
        end
    },
    {
        "nvim-mini/mini.comment",
        version = false,
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    }



}
