local autogroup = vim.api.nvim_create_augroup("lsp_config", {})
local autocmd = vim.api.nvim_create_autocmd

-- Diagnostic signs in the gutter (aside the line number) + underline in the buffer
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	underline = true,
	severity_sort = true,
	virtual_text = false, -- handled by tiny-inline-diagnostic.nvim
})

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
		map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
		map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")

		-- inlay hints toggle
		map("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = e.buf }))
		end, "Toggle inlay hints")

		-- LSP control
		map("n", "<leader>lq", ":LspStop<CR>", "LSP stop")
		map("n", "<leader>lr", ":LspRestart<CR>", "LSP restart")
		map("n", "<leader>li", ":LspInfo<CR>", "LSP info")

	end,
})

-- Show LSP progress (e.g. rust-analyzer "Indexing…") via the snacks notifier,
-- so it's obvious when a server is still loading and hover/refs aren't ready yet.
autocmd("LspProgress", {
	group = autogroup,
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

