-- `<leader>` is resolved when a mapping is *created*, not when it is pressed, so
-- mapleader has to be set before anything that defines one — that means before
-- `config.remap` and before lazy.nvim evaluates any plugin `keys` spec.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.remap")
require("config.set")

-- `vim._core.ui2` is a private API and may disappear on a Neovim upgrade; a
-- missing UI is not worth a hard startup failure.
pcall(function()
	require("vim._core.ui2").enable({})
end)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- Check for plugin updates, but silently — `notify = true` (the default) pops a
	-- snacks notifier toast in the top-right whenever updates are found.
	checker = { enabled = true, notify = false },
})
