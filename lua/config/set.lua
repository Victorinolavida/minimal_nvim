vim.opt.guicursor = ""

-- Force truecolor. Outside tmux nvim auto-detects it via $COLORTERM, but tmux
-- doesn't propagate that and the tmux-256color terminfo has no truecolor flag,
-- so without this the colorscheme falls back to 256-color inside tmux and
-- looks like the config didn't load. tmux passes RGB through via its own
-- `terminal-overrides ",*256col*:Tc"`.
vim.opt.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.cmdheight = 0

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.showmatch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 300
vim.opt.cursorline = true

vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")

vim.opt.colorcolumn = "0"

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
