vim.opt.guicursor = ""

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

-- Folding. The expression itself is set per-buffer in the treesitter FileType
-- autocmd; these just make sure files open fully unfolded (zc/za to fold,
-- zR/zM for all).
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Tabline: `<n> <filename>` per tab, current one highlighted. `%<n>T` makes
-- each label mouse-clickable.
function _G.tabline()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}
	for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local name = vim.api.nvim_buf_get_name(buf)
		name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
		local hl = tab == current and "%#TabLineSel#" or "%#TabLine#"
		parts[#parts + 1] = ("%s%%%dT %d %s %%T"):format(hl, i, i, name)
	end
	return table.concat(parts) .. "%#TabLineFill#"
end

vim.opt.tabline = "%!v:lua.tabline()"

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
