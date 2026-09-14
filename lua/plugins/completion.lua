return {
    'saghen/blink.cmp',
    build = 'cargo build --release', -- for delimiters
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = "1.*",
    lazy = false,
    opts = {
        keymap = {
            preset = "none",
            ["<Up>"] = false,
            ["<Down>"] = false,
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,

            ["<C-space>"] = { "show", "fallback" },

            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<Right>"] = false,
            ["<Left>"] = false,
            ["<C-y>"] = { "select_and_accept", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
        },
        snippets = { preset = "default" },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },
        signature = { enabled = true },
        completion = {
            menu = {
                draw = {
                    columns = {
                        { "kind_icon", "label", "source_name", gap = 1 },
                    },
                    components = {
                        source_name = {
                            text = function(ctx)
                                return "[" .. ctx.source_name .. "]"
                            end,
                        },
                    },
                }
            },
            accept = { auto_brackets = { enabled = true } },

            documentation = {
                auto_show = true,
                -- auto_show_delay_ms = 250,
                -- treesitter_highlighting = true,
                -- window = { border = "rounded" },
            },


        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },

    },
    opts_extend = { "sources.default" },
}
