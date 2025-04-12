return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
	},
	config = function()
		--config  trouble
		local actions = require("telescope.actions")
		local trouble = require("trouble.sources.telescope")
		require("telescope").setup({
			defaults = {
				ignore_patterns = {
					"node_modules", --ignore node_modules
					"__pycache__",
					".git",
					".hg",
					".svn",
					".idea",
					".DS_Store",
					".vscode",
					".git",
					"dist",
					"build",
					".next",
				},
				mappings = {
					i = { ["<c-t>"] = trouble.open },
					n = { ["<c-t>"] = trouble.open },
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[s]earch [f]ile" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "find git files" })
		vim.keymap.set("n", "<leader>fw", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end, { desc = "find files with word under cursor" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find buffers" })
		vim.keymap.set("n", "<leader>fW", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "find files with word under cursor" })

		vim.keymap.set("n", "<leader>fr", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "find files with grep" })

		-- ":Telescope find_files find_command=rg,--files,--hidden,--no-ignore-vcs,--no-ignore,--follow,--glob,!.git,--glob,!node_modules,--glob,!tmp,--glob,!build<CR>",
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fa", function()
			builtin.find_files({
				find_command = {
					"rg",
					"--files",
					"--hidden",
					"--no-ignore-vcs",
					"--no-ignore",
					"--follow",
					"--glob",
					"!.git",
					"--glob",
					"!node_modules",
					"--glob",
					"!tmp",
					"--glob",
					"!build",
					"--glob",
					"!.devbox",
					"--glob",
					"!__pycache__",
					"--glob",
					"!dist",
					"--glob",
					"!.next",
					"--glob",
					"!.idea",
				},
			})
		end, { desc = "Find Files .env" })
		vim.keymap.set("n", "<leader>fl", function()
			builtin.live_grep({
				only_sort_text = true,
				layout_strategy = "vertical",
				layout_config = {
					width = 0.9,
					height = 0.9,
				},
				additional_args = function()
					return {
						"--hidden",
						"--no-ignore-vcs",
						"--no-ignore",
						"--glob",
						"!.git",
						"--glob",
						"!node_modules",
						"--glob",
						"!tmp",
						"--glob",
						"!build",
						"--glob",
						"!dist",
						"--glob",
						"!out",
						"--glob",
						"!.devbox",
						"--glob",
						"!__pycache__",
						"--glob",
						"!.venv",
						"--glob",
						"!venv",
						"--glob",
						"!.next",
						"--glob",
						"!.turbo",
						"--glob",
						"!.parcel-cache",
						"--glob",
						"!.expo",
						"--glob",
						"!.expo-shared",
						"--glob",
						"!.idea",
						"--glob",
						"!.vscode",
						"--glob",
						"!coverage",
						"--glob",
						"!.sass-cache",
						"--glob",
						"!.cache",
					}
				end,
			})
		end, { desc = "Live Grep" })
	end,
}
