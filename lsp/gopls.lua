--- @class go_dir_custom_args
---
--- @field envvar_id string
---
--- @field custom_subdir string?

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
	local cmd = { "go", "env", custom_args.envvar_id }
	vim.system(cmd, { text = true }, function(output)
		local res = vim.trim(output.stdout or "")
		if output.code == 0 and res ~= "" then
			if custom_args.custom_subdir and custom_args.custom_subdir ~= "" then
				res = res .. custom_args.custom_subdir
			end
			on_complete(res)
		else
			vim.schedule(function()
				vim.notify(
					("[gopls] identify " .. custom_args.envvar_id .. " dir cmd failed with code %d: %s\n%s"):format(
						output.code,
						vim.inspect(cmd),
						output.stderr
					)
				)
			end)
			on_complete(nil)
		end
	end)
end

---@return string?
local function get_std_lib_dir()
	if std_lib and std_lib ~= "" then
		return std_lib
	end

	identify_go_dir({ envvar_id = "GOROOT", custom_subdir = "/src" }, function(dir)
		if dir then
			std_lib = dir
		end
	end)
	return std_lib
end

---@return string?
local function get_mod_cache_dir()
	if mod_cache and mod_cache ~= "" then
		return mod_cache
	end

	identify_go_dir({ envvar_id = "GOMODCACHE" }, function(dir)
		if dir then
			mod_cache = dir
		end
	end)
	return mod_cache
end

---@param fname string
---@return string?
local function get_root_dir(fname)
	if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
		local clients = vim.lsp.get_clients({ name = "gopls" })
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end
	if std_lib and fname:sub(1, #std_lib) == std_lib then
		local clients = vim.lsp.get_clients({ name = "gopls" })
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end

	-- Honour `GOWORK=off`: skip go.work discovery entirely so a project is
	-- scoped to its own module.
	local gowork_off = vim.trim(vim.fn.getenv("GOWORK") or "") == "off"

	local mod_root = vim.fs.root(fname, "go.mod")
	local work_root = not gowork_off and vim.fs.root(fname, "go.work") or nil

	-- A go.work found above this file only counts if it actually `use`s this
	-- file's module. Otherwise it's a stray go.work in a shared parent dir
	-- (e.g. above several unrelated projects), and honouring it would merge
	-- them into one workspace and leak imports across projects. In that case
	-- fall back to the module's own root so gopls stays scoped.
	if work_root and mod_root and work_root ~= mod_root then
		local uses_module = false
		local ok, lines = pcall(vim.fn.readfile, work_root .. "/go.work")
		if ok then
			for _, line in ipairs(lines) do
				local path = line:match("^%s*use%s+[\"']?(%S-)[\"']?%s*$")
					or line:match("^%s*[\"']?(%.%S-)[\"']?%s*$") -- entry inside a use ( ... ) block
				if path then
					-- `use` paths are normally relative to the go.work dir, but
					-- may be absolute; only join relative ones.
					local abs = path:sub(1, 1) == "/" and vim.fs.normalize(path)
						or vim.fs.normalize(work_root .. "/" .. path)
					if abs == vim.fs.normalize(mod_root) then
						uses_module = true
						break
					end
				end
			end
		end
		if not uses_module then
			return mod_root
		end
	end

	return work_root or mod_root or vim.fs.root(fname, ".git")
end

---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		get_mod_cache_dir()
		get_std_lib_dir()
		-- see: https://github.com/neovim/nvim-lspconfig/issues/804
		on_dir(get_root_dir(fname))
	end,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				shadow = true,
				useany = true,
				nilness = true,
			},
			staticcheck = true,
			gofumpt = true,
			usePlaceholders = true,
			completeUnimported = true,
			completeFunctionCalls = true,
			-- Keep gopls' view scoped to the project and off noisy dirs, so
			-- unimported-completion doesn't surface packages from unrelated
			-- trees that happen to sit nearby.
			directoryFilters = { "-.git", "-node_modules", "-.devbox" },
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			codelenses = {
				generate = true,
				tidy = true,
			},
		},
	},
}
