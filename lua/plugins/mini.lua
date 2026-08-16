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

			-- mini.snippets marks empty tabstops with inline virtual text ("•"/"∎"),
			-- cleared only when the session stops. Its default autostop is narrow
			-- (final tabstop current + an edit or Normal mode), and jumping wraps past
			-- the final tabstop rather than ending, so abandoned sessions leave the
			-- markers on screen. Stop eagerly instead.
			local group = vim.api.nvim_create_augroup("mini_snippets_autostop", {})

			-- Reaching the final tabstop means the snippet is done.
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "MiniSnippetsSessionJump",
				callback = function(args)
					if args.data.tabstop_to == "0" then
						MiniSnippets.session.stop()
					end
				end,
			})

			-- Leaving Insert mode abandons the session (nested ones included).
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "MiniSnippetsSessionStart",
				callback = function()
					vim.api.nvim_create_autocmd("ModeChanged", {
						pattern = "*:n",
						once = true,
						callback = function()
							while MiniSnippets.session.get() do
								MiniSnippets.session.stop()
							end
						end,
					})
				end,
			})
		end,
	},
}
