local autogroup = vim.api.nvim_create_augroup("lsp_config", {})
local autocmd = vim.api.nvim_create_autocmd

local M = {}

-- Re-apply our own lsp/*.lua on top of nvim-lspconfig's.
--
-- Neovim merges every `lsp/<name>.lua` found on the runtimepath in rtp order,
-- with LATER entries winning (see `vim/lsp.lua`, "Resolve configs from
-- lsp/*.lua"). Our config dir comes first and nvim-lspconfig second, so
-- lspconfig's copy of a server silently overrides ours — e.g. our gopls
-- `root_dir` (the go.work scoping fix) never ran.
--
-- Calls to `vim.lsp.config()` from outside an `lsp/` file have higher
-- precedence than any rtp file, so loading ours again through that API puts
-- them back on top. lspconfig then only fills in keys we don't define, which
-- is what we want it for.
--
-- Must run AFTER lazy.nvim's setup: lsp/eslint.lua and lsp/tailwindcss.lua
-- `require("lspconfig.util")` at load time.
--
-- Caveat: the merge is `tbl_deep_extend("force", …)`, which merges list-like
-- fields index-by-index rather than replacing them. If lspconfig lists more
-- entries than we do for `cmd`/`filetypes`/`root_markers`, its extra trailing
-- entries survive. Check with `:checkhealth vim.lsp` if a server misbehaves.
function M.apply_local_configs()
	local config_dir = vim.fn.stdpath("config") .. "/lsp/"
	for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		if vim.startswith(path, config_dir) then
			local name = vim.fn.fnamemodify(path, ":t:r")
			local ok, config = pcall(dofile, path)
			if ok and type(config) == "table" then
				vim.lsp.config(name, config)
			elseif not ok then
				vim.notify(("[lsp] failed to load %s: %s"):format(path, config), vim.log.levels.ERROR)
			end
		end
	end
end

-- Diagnostic signs in the gutter (aside the line number) + underline in the buffer
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		-- colour the line number itself (not just the sign) per severity
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
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
		map("n", "<leader>F", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")
		map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		-- move between diagnostics ([prev, ]next is the convention)
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, "Previous diagnostic")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, "Next diagnostic")

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
		vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

return M
