return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 300,
			virt_text_pos = "eol",
		},
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- navigate hunks
			map("n", "]h", gs.next_hunk, "Next hunk")
			map("n", "[h", gs.prev_hunk, "Prev hunk")

			-- stage / reset
			map("n", "<leader>hs", gs.stage_hunk, "[h]unk [s]tage")
			map("n", "<leader>hr", gs.reset_hunk, "[h]unk [r]eset")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "[h]unk [s]tage selection")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "[h]unk [r]eset selection")
			map("n", "<leader>hS", gs.stage_buffer, "[h]unk [S]tage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "[h]unk [R]eset buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "[h]unk [u]ndo stage")

			-- preview / blame / diff
			map("n", "<leader>hp", gs.preview_hunk, "[h]unk [p]review")
			map("n", "<leader>hb", gs.toggle_current_line_blame, "[h]unk [b]lame toggle")
			map("n", "<leader>hd", gs.diffthis, "[h]unk [d]iff")
		end,
	},
}
