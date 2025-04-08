-- KEYMAPS
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

-- Explorer
-- vim.cmd.Ex()
-- vim.keymap.set("n", "<leader>pv", function()
--     vim.cmd("NvimTreeToggle")
-- end, { noremap = true, silent = true, desc = "Toggle [P]roject [V]iew" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { noremap = true, desc = "Select all" })

-- Replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Error go
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "[e]rror golang" })

-- format
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { desc = "[f]ormat" })

-- yank selection to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
--yank current line to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- paste from clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])

-- restart lsp
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- move between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- new tab
vim.keymap.set("n", "te", ":tabedit<Return>", { noremap = true, silent = true, desc = "new [t]ab [e]dit" })
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- split window
vim.keymap.set("n", "ss", ":split<Return>", opts)
vim.keymap.set("n", "sv", ":vsplit<Return>", opts)
