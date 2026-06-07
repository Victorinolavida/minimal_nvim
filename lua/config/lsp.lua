local autogroup = vim.api.nvim_create_augroup("config", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = autogroup,
	callback = function(e)
		if vim.fn.getfsize(vim.api.nvim_buf_get_name(e.buf)) > 1024 * 1024 then
			vim.lsp.buf_detach_client(e.buf, e.data.client_id)
			return
		end

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
		map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		-- move between diagnostics ([prev, ]next is the convention)
		map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

		-- LSP control
		map("n", "<leader>lq", ":LspStop<CR>", "LSP stop")
		map("n", "<leader>lr", ":LspRestart<CR>", "LSP restart")
		map("n", "<leader>li", ":LspInfo<CR>", "LSP info")

		-- move between quickfix list
		vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz", opts)
		vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz", opts)
	end,
})

-- Otras configuraciones útiles
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Autocompletado más eficiente
