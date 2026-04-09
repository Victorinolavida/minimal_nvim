---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"ruff.toml",
		".ruff.toml",
		".git",
	},
	settings = {
		ruff = {
			lint = { enable = true },
			format = { enable = true },
		},
	},
	on_attach = function(client, _)
		-- disable hover in favor of pyright
		client.server_capabilities.hoverProvider = false
	end,
}
