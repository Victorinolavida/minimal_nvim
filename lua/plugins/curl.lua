return {
	"oysandvik94/curl.nvim",
	cmd = { "CurlOpen" },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	init = function()
		-- Close curl buffers before session save so they are never persisted.
		-- autosave_ignore_filetypes alone is unreliable: tbl_deep_extend replaces
		-- the default list, and the curl tab itself survives buffer deletion.
		vim.api.nvim_create_autocmd("User", {
			pattern = "SessionSavePre",
			callback = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(buf) then
						local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
						local name = vim.api.nvim_buf_get_name(buf)
						if ft == "curl" or name:match("^Curl output") then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end
			end,
		})
	end,
	config = true,
}
