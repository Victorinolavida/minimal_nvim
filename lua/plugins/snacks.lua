-- Directories that should never appear in file/grep results. Shared by every
-- picker below so `<leader>ff` and `<leader>fl` agree on what "the project" is.
local exclude = {
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
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<C-t>",
			function()
				Snacks.terminal(nil, { win = { position = "bottom" } })
			end,
			mode = { "n", "t" },
			desc = "Toggle terminal",
		},
		{
			"<leader>tf",
			function()
				Snacks.terminal(nil, { win = { position = "float" } })
			end,
			desc = "Toggle floating terminal",
		},
		{
			"<leader>th",
			function()
				Snacks.terminal(nil, { win = { position = "bottom" } })
			end,
			desc = "Toggle horizontal terminal",
		},

		-- ── Pickers ──────────────────────────────────────────────────────────
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ exclude = exclude })
			end,
			desc = "[f]ind [f]iles",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find git files",
		},
		{
			"<leader>fa",
			-- everything: hidden files and gitignored ones too (.env, build output)
			function()
				Snacks.picker.files({ hidden = true, ignored = true, follow = true, exclude = exclude })
			end,
			desc = "Find all files (hidden + ignored)",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fl",
			-- live grep across the project, searching hidden/ignored files
			function()
				Snacks.picker.grep({
					hidden = true,
					ignored = true,
					exclude = exclude,
					layout = { preset = "vertical" },
				})
			end,
			desc = "Live grep",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word({ exclude = exclude })
			end,
			mode = { "n", "x" },
			desc = "Grep word under cursor",
		},
		{
			"<leader>fW",
			function()
				Snacks.picker.grep({
					search = vim.fn.expand("<cWORD>"),
					regex = false,
					live = false,
					exclude = exclude,
				})
			end,
			desc = "Grep WORD under cursor",
		},
		{
			"<leader>fr",
			-- literal (non-regex) search typed up front, then browse the results
			function()
				local search = vim.fn.input("Grep > ")
				if vim.trim(search) == "" then
					return
				end
				Snacks.picker.grep({ search = search, regex = false, live = false, exclude = exclude })
			end,
			desc = "Grep prompt",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help tags",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume last picker",
		},
		{
			"<leader>xx",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>pk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Search keymaps",
		},
	},
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		indent = { enabled = true, indent = { char = "┊" } },
		notifier = { enabled = true },
		lazygit = { enabled = true },
		picker = { enabled = true },
		terminal = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		image = { enabled = false },
		zen = { enabled = true },
		dim = { enabled = false },
		scope = { enabled = true },
	},
}
