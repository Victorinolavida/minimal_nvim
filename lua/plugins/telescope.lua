return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional but recommended
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		-- local trouble = require("trouble.sources.telescope")
		local builtin = require("telescope.builtin")

		-- shared ignore globs for rg
		local ignore_globs = {}
		for _, dir in ipairs({
			".git",
			"node_modules",
			"tmp",
			"build",
			"dist",
			"out",
			".devbox",
			"__pycache__",
			".venv",
			"venv",
			".next",
			".turbo",
			".parcel-cache",
			".expo",
			".expo-shared",
			".idea",
			".vscode",
			"coverage",
			".sass-cache",
			".cache",
		}) do
			table.insert(ignore_globs, "--glob")
			table.insert(ignore_globs, "!" .. dir)
		end

		require("telescope").setup({
			defaults = vim.tbl_extend("force", require("telescope.themes").get_ivy(), {
				-- mappings = {
				-- 	i = { ["<c-t>"] = trouble.open },
				-- 	n = { ["<c-t>"] = trouble.open },
				-- },
			}),
		})

		local map = vim.keymap.set
		map("n", "<leader>ff", builtin.find_files, { desc = "[s]earch [f]ile" })
		map("n", "<C-p>", builtin.git_files, { desc = "find git files" })
		map("n", "<leader>fb", builtin.buffers, { desc = "find buffers" })
		map("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })

		map("n", "<leader>fw", function()
			builtin.grep_string({ search = vim.fn.expand("<cword>") })
		end, { desc = "grep word under cursor" })
		map("n", "<leader>fW", function()
			builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
		end, { desc = "grep WORD under cursor" })
		map("n", "<leader>fr", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "grep prompt" })

		map("n", "<leader>fa", function()
			builtin.find_files({
				find_command = vim.list_extend({
					"rg",
					"--files",
					"--hidden",
					"--no-ignore-vcs",
					"--no-ignore",
					"--follow",
				}, ignore_globs),
			})
		end, { desc = "Find all files (incl. hidden/ignored)" })

		map("n", "<leader>fl", function()
			local function ivy(opts)
				return require("telescope.themes").get_ivy(opts or {})
			end
			builtin.live_grep(ivy({
				layout_config = { height = 0.5 },
				additional_args = function()
					return vim.list_extend({ "--hidden", "--no-ignore-vcs", "--no-ignore" }, ignore_globs)
				end,
			}))
			-- builtin.live_grep({
			-- 	layout_strategy = "vertical",
			-- 	layout_config = { width = 0.9, height = 0.9 },
			-- 	additional_args = function()
			-- 		return vim.list_extend({ "--hidden", "--no-ignore-vcs", "--no-ignore" }, ignore_globs)
			-- 	end,
			-- })
			--
		end, { desc = "Live Grep" })

		map("n", "<leader>fp", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end, { desc = "search files in config directory" })
		--       vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Help tags" })
	end,
}
