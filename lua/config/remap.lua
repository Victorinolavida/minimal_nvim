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

-- toggle ; at end of line
local function toggle_char_eol(char)
	return function()
		local line = vim.api.nvim_get_current_line()
		local trimmed = line:gsub("%s+$", "")
		if trimmed:sub(-1) == char then
			vim.api.nvim_set_current_line(trimmed:sub(1, -2))
		else
			vim.api.nvim_set_current_line(trimmed .. char)
		end
	end
end
vim.keymap.set({ "n", "v" }, "<C-;>", toggle_char_eol(";"), { desc = "Toggle ; at eol" })

-- restart lsp
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

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
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "go",
-- 	callback = function(ev)
-- 		local buf = ev.buf
-- 		vim.keymap.set("n", "<leader>gr", "<cmd>!go run %<CR>", { buffer = buf, desc = "[g]o [r]un file" })
-- 		vim.keymap.set("n", "<leader>gt", "<cmd>!go test ./...<CR>", { buffer = buf, desc = "[g]o [t]est all" })
-- 		vim.keymap.set("n", "<leader>gT", "<cmd>!go test %:h<CR>", { buffer = buf, desc = "[g]o [T]est package" })
-- 		vim.keymap.set("n", "<leader>gb", "<cmd>!go build ./...<CR>", { buffer = buf, desc = "[g]o [b]uild" })
-- 		vim.keymap.set("n", "<leader>ga", function()
-- 			local file = vim.fn.expand("%")
-- 			if file:match("_test%.go$") then
-- 				vim.cmd("edit " .. file:gsub("_test%.go$", ".go"))
-- 			else
-- 				vim.cmd("edit " .. file:gsub("%.go$", "_test.go"))
-- 			end
-- 		end, { buffer = buf, desc = "[g]o [a]lternate test/impl" })
-- 	end,
-- })

-- move between quickfix list
vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

-- ── VS Code (vscode-neovim) ────────────────────────────────────────────────
-- Mirrors telescope/window keymaps so muscle memory works inside VS Code.
if vim.g.vscode then
  local vscode = require("vscode")
  local map = function(key, cmd, desc)
    vim.keymap.set("n", key, function() vscode.call(cmd) end, { desc = desc })
  end

  -- File search (telescope.ff / C-p)
  map("<leader>ff", "workbench.action.quickOpen", "Find files")
  map("<C-p>", "workbench.action.quickOpen", "Find files")

  -- Live grep (telescope.fl / fr)
  map("<leader>fl", "workbench.action.findInFiles", "Live grep")
  map("<leader>fr", "workbench.action.findInFiles", "Grep")

  -- Grep word under cursor (telescope.fw)
  vim.keymap.set("n", "<leader>fw", function()
    vscode.call("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
  end, { desc = "Grep word under cursor" })

  -- Buffer list (telescope.fb)
  map("<leader>fb", "workbench.action.showAllEditors", "Find buffers")

  -- Window navigation (C-h/j/k/l)
  map("<C-h>", "workbench.action.focusLeftGroup", "Focus left")
  map("<C-j>", "workbench.action.focusBelowGroup", "Focus below")
  map("<C-k>", "workbench.action.focusAboveGroup", "Focus above")
  map("<C-l>", "workbench.action.focusRightGroup", "Focus right")

  -- Splits (ss / sv)
  map("ss", "workbench.action.splitEditorDown", "Split down")
  map("sv", "workbench.action.splitEditorRight", "Split right")

  -- Tabs (tab / s-tab)
  map("<tab>", "workbench.action.nextEditor", "Next editor")
  map("<s-tab>", "workbench.action.previousEditor", "Prev editor")

  -- Format (<leader>F)
  map("<leader>F", "editor.action.formatDocument", "Format document")

  -- Quickfix nav (<leader>cn / cp)
  map("<leader>cn", "editor.action.marker.nextInFiles", "Next problem")
  map("<leader>cp", "editor.action.marker.prevInFiles", "Prev problem")
end
