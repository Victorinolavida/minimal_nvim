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

-- nvim-lspconfig ships its own lsp/rust_analyzer.lua. Because it sits later on the
-- runtimepath than our config, Neovim's lsp/ merge (last-wins) makes lspconfig's
-- root_dir/settings shadow ours — so our standalone-file fallback never runs.
-- vim.lsp.config() has the highest precedence, so re-register our file through it.
local rust_cfg_ok, rust_cfg = pcall(dofile, vim.fn.stdpath("config") .. "/lsp/rust_analyzer.lua")
if rust_cfg_ok then
	vim.lsp.config("rust_analyzer", rust_cfg)
end

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

-- Otras configuraciones útiles
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Autocompletado más eficiente
