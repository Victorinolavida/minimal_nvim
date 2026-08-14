return {
	{
		"nvim-mini/mini.completion",
		version = false,
		config = function()
			require("mini.completion").setup({
				lsp_completion = {
					auto_setup = true,
				},
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			-- Prompt buffers (snacks picker input, vim.ui.input) are not code: without
			-- this, mini.completion pops a buffer-word menu over the picker's own
			-- results list as soon as you type.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("mini_completion_prompt_off", {}),
				pattern = { "snacks_picker_input", "snacks_input" },
				callback = function(args)
					vim.b[args.buf].minicompletion_disable = true
				end,
			})
		end,
	},
	{
		"nvim-mini/mini.snippets",
		version = false,
		-- `gen_loader.from_lang()` reads `snippets/` dirs off the runtimepath; without
		-- friendly-snippets there is nothing there and no snippet ever expands.
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local MiniSnippets = require("mini.snippets")
			MiniSnippets.setup({
				snippets = {
					MiniSnippets.gen_loader.from_lang(),
				},
			})
			MiniSnippets.start_lsp_server({ match = false })
		end,
	},
}
