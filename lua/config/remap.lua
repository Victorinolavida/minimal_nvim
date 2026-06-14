-- KEYMAPS
local opts = { noremap = true, silent = true }

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
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

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
vim.keymap.set("n", "<leader>t", ":tabedit %<Return>", opts)

-- split window
vim.keymap.set("n", "ss", ":split<Return>", opts)
vim.keymap.set("n", "sv", ":vsplit<Return>", opts)

-- re-size window
vim.keymap.set("n", "<leader>>", "<C-w>>", opts)
vim.keymap.set("n", "<leader><", "<C-w><", opts)

-- Go filetype keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function(ev)
		local buf = ev.buf
		vim.keymap.set("n", "<leader>gr", "<cmd>!go run %<CR>", { buffer = buf, desc = "[g]o [r]un file" })
		vim.keymap.set("n", "<leader>gt", "<cmd>!go test ./...<CR>", { buffer = buf, desc = "[g]o [t]est all" })
		vim.keymap.set("n", "<leader>gT", "<cmd>!go test %:h<CR>", { buffer = buf, desc = "[g]o [T]est package" })
		vim.keymap.set("n", "<leader>gb", "<cmd>!go build ./...<CR>", { buffer = buf, desc = "[g]o [b]uild" })
		vim.keymap.set("n", "<leader>ga", function()
			local file = vim.fn.expand("%")
			if file:match("_test%.go$") then
				vim.cmd("edit " .. file:gsub("_test%.go$", ".go"))
			else
				vim.cmd("edit " .. file:gsub("%.go$", "_test.go"))
			end
		end, { buffer = buf, desc = "[g]o [a]lternate test/impl" })
	end,
})
