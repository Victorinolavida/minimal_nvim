require("config.lazy")
require("config.set")
require("config.remap")

local autogroup = vim.api.nvim_create_augroup("config", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = autogroup,
	callback = function(e)
		local opts = { buffer = e.buf, silent = true, noremap = true }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, { unpack(opts), desc = "Go to definition" })

		vim.keymap.set("n", "gr", function()
			vim.lsp.buf.references()
		end, { unpack(opts), desc = "Go to references" })

		-- vim.keymap.set("n", "<leader>ts", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, { unpack(opts), desc = "Go to declaration" })

		vim.keymap.set("n", "gi", function()
			vim.lsp.buf.implementation()
		end, { unpack(opts), desc = "Go to implementation" })

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, { unpack(opts), desc = "Show hover" })

		vim.keymap.set("n", "<leader>ws", function()
			vim.lsp.buf.workspace_symbol()
		end, { unpack(opts), desc = "Workspace symbols" })

		vim.keymap.set("n", "<leader>wd", function()
			vim.diagnostic.open_float()
		end, { unpack(opts), desc = "Open diagnostics" })

		vim.keymap.set("n", "<leader>wa", function()
			vim.lsp.buf.code_action()
		end, { unpack(opts), desc = "Workspace Actions" })

		vim.keymap.set("n", "<leader>wr", function()
			vim.lsp.buf.references()
		end, { unpack(opts), desc = "Workspace References" })

		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, { unpack(opts), desc = "Rename" })

		vim.keymap.set("i", "<C-s>", function()
			vim.lsp.buf.signature_help()
		end, { unpack(opts), desc = "Signature help" })

		-- move between diagnostics
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, { unpack(opts), desc = "Next diagnostic" })

		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, { unpack(opts), desc = "Previous diagnostic" })

		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { unpack(opts), desc = "List workspace folders" })

		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { unpack(opts), desc = "Type definition" })
		-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { unpack(opts), desc = "Rename" })
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
vim.opt.isfname:append("@-@") -- Incluir guion en los nombres de archivo
