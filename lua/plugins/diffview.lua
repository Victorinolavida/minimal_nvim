return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[g]it [d]iffview open" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "[g]it file [h]istory" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "[g]it repo [H]istory" },
		{ "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "[g]it diffview close" },
	},
	opts = {},
}
