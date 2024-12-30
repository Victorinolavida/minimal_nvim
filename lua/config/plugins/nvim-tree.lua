return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		require("nvim-tree").setup({

			sync_root_with_cwd = true,
			-- hijack_unnamed_buffer_when_opening = false,
			update_focused_file = {
				enable = true,
				update_cwd = true,
				ignore_list = {},
			},

			actions = {
				expand_all = {
					exclude = {
						"node_modules",
						".git",
						".cache",
						".vscode",
						".idea",
						".DS_Store",
						".gitignore",
						".gitattributes",
						".gitmodules",
						".gitkeep",
						".gitlab-ci.yml",
						".gitlab",
					},
				},
			},
			hijack_netrw = true,
			hijack_cursor = true,
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},

			filters = {
				custom = { "^.git$" },
			},
			git = {
				enable = true,
			},
			filesystem_watchers = {
				ignore_dirs = { "node_modules" },
			},

			renderer = {
				root_folder_label = false,
				highlight_git = true,
				indent_markers = { enable = true },
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
					glyphs = {
						default = "󰈚",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
						},
						git = {
							-- modified = "", -- Archivo modificado
							-- removed = "", -- Archivo eliminado
							renamed = "", -- Archivo renombrado
							untracked = "", -- Archivo no trackeado
							ignored = "", -- Archivo ignorado por .gitignore
							staged = "", -- Archivo en stage listo para commit
                            unmerged = "",
							-- conflict = "", -- Conflicto de merge
						},
					},
				},
			},
		})
		--       local api = require "nvim-tree.api"
		-- api.events.subscribe(api.events.Event.FileCreated, function(file)
		-- 	vim.cmd("edit " .. file.fname)
		-- end)
	end,
}
