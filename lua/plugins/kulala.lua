return {
	"mistweaverco/kulala.nvim",
	tag = "v5.3.4",
	ft = { "http", "rest" },
	keys = {
		{ "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
		{ "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Run all requests" },
		{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Next request" },
		{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Prev request" },
		{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
		{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect request" },
	},
	opts = {
		default_view = "body",
		split_direction = "vertical",
	},
}
