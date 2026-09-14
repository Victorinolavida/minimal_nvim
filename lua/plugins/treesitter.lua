return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        dependencies = {
            {

                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                init = function()
                    -- Disable entire built-in ftplugin mappings to avoid conflicts.
                    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
                    vim.g.no_plugin_maps = true

                    -- Or, disable per filetype (add as you like)
                    -- vim.g.no_python_maps = true
                    -- vim.g.no_ruby_maps = true
                    -- vim.g.no_rust_maps = true
                    -- vim.g.no_go_maps = true
                end,

            }
        },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter-textobjects").setup {}
            local treesitter = require("nvim-treesitter")
            treesitter.setup()
            treesitter.setup()

            treesitter.install({
                "rust",
                "javascript",
                "go",
                "python",
                "vim",
                "vimdoc",
                "yaml",
                "zsh",
                "typescript",
                "toml",
                "tsx",
                "tsv",
                "terraform",
                "sql",
                "regex",
                "html",
                "css",
                "json",
                "bash",
                "http",
                "dockerfile",
            })
                :wait(300000) -- wait max. 5 minutes    end,
            local grp = vim.api.nvim_create_augroup("treesitter-group", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = "*",
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype

                    local lang = vim.treesitter.language.get_lang(ft)
                    if not lang then
                        return
                    end

                    local ok_add = pcall(vim.treesitter.language.add, lang)
                    if not ok_add then
                        return
                    end

                    pcall(vim.treesitter.start, buf, lang)
                end,
            })
        end,
    },
}
