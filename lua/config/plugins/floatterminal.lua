return {
	name = "float_terminal",
	dir = vim.fn.stdpath("config") .. "/lua/config/plugins/local/float_terminal",
	config = function()
		require("config.plugins.local.float_terminal").setup()
	end,
}
