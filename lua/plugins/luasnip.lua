return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",

		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			-- require("nconf.snippets.all") // add snippets
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		dependencies = { "L3MON4D3/LuaSnip" },
		version = "1.*",
		opts = {
			keymap = { preset = "super-tab" },
			snippets = { preset = "luasnip" },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		},
	},
}
