local autogroup = vim.api.nvim_create_augroup("config", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = autogroup,
	callback = function(e)
		local opts = { buffer = e.buf, silent = true, noremap = true }
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end

		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Go to references")
		map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
		map("n", "<leader>wd", vim.diagnostic.open_float, "Open diagnostics")
		map("n", "<leader>wa", vim.lsp.buf.code_action, "Code actions")
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		-- move between diagnostics ([prev, ]next is the convention)
		map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

		-- move between quickfix list
		vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz", opts)
		vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz", opts)
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Otras configuraciones útiles
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Autocompletado más eficiente
