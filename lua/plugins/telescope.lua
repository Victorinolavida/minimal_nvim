return {
	"nvim-telescope/telescope.nvim",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	keys = {
		{ "<leader>ff" }, { "<C-p>" }, { "<leader>fw" }, { "<leader>fb" },
		{ "<leader>fW" }, { "<leader>fr" }, { "<leader>fh" }, { "<leader>fa" }, { "<leader>fl" },
	},
	config = function()
		local trouble = require("trouble.sources.telescope")

		-- Base ripgrep command shared by grep pickers: search hidden + ignored
		-- files, but skip the usual noise dirs. Extra flags/paths can be typed
		-- inline via live-grep-args (e.g. `expression -g *.lua`).
		local vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--no-ignore-vcs",
			"--no-ignore",
		}
		for _, dir in ipairs({
			".git", "node_modules", "tmp", "build", "dist", "out",
			".devbox", "__pycache__", ".venv", "venv", ".next", ".turbo",
			".parcel-cache", ".expo", ".expo-shared", ".idea", ".vscode",
			"coverage", ".sass-cache", ".cache",
		}) do
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!" .. dir)
		end

		require("telescope").setup({
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
				file_ignore_patterns = {
					"node_modules",
					"__pycache__",
					".git",
					".hg",
					".svn",
					".idea",
					".DS_Store",
					".vscode",
					"dist",
					"build",
					".next",
				},
				mappings = {
					i = { ["<c-t>"] = trouble.open },
					n = { ["<c-t>"] = trouble.open },
				},
			},
			extensions = {
				live_grep_args = {
					-- treat the prompt like a real rg command line: pattern +
					-- optional flags/paths, with automatic quoting of the pattern.
					auto_quoting = true,
				},
			},
		})

		require("telescope").load_extension("live_grep_args")

		local builtin = require("telescope.builtin")
		local lga = require("telescope").extensions.live_grep_args

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
					"--glob",
					"!.vscode",
					"--glob",
					"!.venv",
				},
			})
		end, { desc = "Find Files .env" })
		vim.keymap.set("n", "<leader>fl", function()
			lga.live_grep_args({
				only_sort_text = true,
				layout_strategy = "vertical",
				layout_config = {
					width = 0.9,
					height = 0.9,
				},
			})
		end, { desc = "Live Grep (args)" })
	end,
}
