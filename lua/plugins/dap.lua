return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>DC", desc = "Debug compose (./program -- args)" },
			{ "<leader>Db", desc = "Toggle breakpoint" },
			{ "<leader>Dc", desc = "Continue / Start" },
			{ "<leader>Ds", desc = "Step over" },
			{ "<leader>Di", desc = "Step into" },
			{ "<leader>Do", desc = "Step out" },
			{ "<leader>Du", desc = "Toggle DAP UI" },
			{ "<leader>Dt", desc = "Debug test (Go)" },
		},
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				config = function()
					local dapui = require("dapui")
					dapui.setup()
					local dap = require("dap")
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.after.event_continued["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {
					commented = true,
				},
			},
			{
				"leoluz/nvim-dap-go",
				config = function()
					require("dap-go").setup()
				end,
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mason-org/mason.nvim" },
				opts = {
					ensure_installed = { "delve" },
					automatic_installation = true,
				},
			},
		},
		config = function()
			local dap = require("dap")

			-- nvim-dap internal log → ~/.cache/nvim/dap.log
			-- levels: TRACE > DEBUG > INFO > WARN > ERROR
			dap.set_log_level("DEBUG")

			-- Emacs `M-x compile` style args prompt: pre-fills the minibuffer
			-- with your last run (persisted to disk so it survives restarts),
			-- lets you edit the whole line, and splits it quote-aware so
			-- `--name "John Doe"` stays one argument. Empty input -> no args.
			local arg_store = vim.fn.stdpath("state") .. "/dap_args.json"

			local function load_args()
				local f = io.open(arg_store, "r")
				if not f then
					return {}
				end
				local ok, data = pcall(vim.json.decode, f:read("*a"))
				f:close()
				return (ok and type(data) == "table") and data or {}
			end

			local function save_args(history)
				local f = io.open(arg_store, "w")
				if f then
					f:write(vim.json.encode(history))
					f:close()
				end
			end

			local function prompt_args(key)
				return function()
					local history = load_args()
					local prev = history[key] or ""
					local input = vim.fn.input({ prompt = "Args: ", default = prev })
					history[key] = input
					save_args(history)
					return require("dap.utils").splitstr(vim.trim(input))
				end
			end

			-- Returns a raw string (for buildFlags: "-tags integration")
			local function prompt_string(key, label)
				return function()
					local history = load_args()
					local prev = history[key] or ""
					local input = vim.fn.input({ prompt = label .. ": ", default = prev })
					history[key] = input
					save_args(history)
					return vim.trim(input)
				end
			end

			-- Parses "KEY=val FOO=bar" into { KEY = "val", FOO = "bar" }
			local function prompt_env(key)
				return function()
					local history = load_args()
					local prev = history[key] or ""
					local input = vim.fn.input({ prompt = "Env (KEY=val ...): ", default = prev })
					history[key] = input
					save_args(history)
					local env = {}
					for pair in vim.trim(input):gmatch("%S+") do
						local k, v = pair:match("^([^=]+)=(.*)$")
						if k then env[k] = v end
					end
					return env
				end
			end

			-- Walk up from the current file to find the Go module root
			-- (the dir containing go.mod). The debugged program runs with
			-- THIS as its working directory, so relative paths it opens
			-- (config files, seed data, output dirs) resolve correctly.
			local function module_root()
				local start = vim.fn.expand("%:p:h")
				local found = vim.fs.find("go.mod", { path = start, upward = true })[1]
				return found and vim.fn.fnamemodify(found, ":h") or vim.fn.getcwd()
			end

			-- Find the main package to debug. Auto-detects the common Go
			-- layouts (cmd/<app>/main.go, cmd/main.go, ./main.go); if there
			-- are several, prompts you to pick via vim.ui.select.
			local function pick_program()
				local root = module_root()
				local mains = vim.fn.glob(root .. "/**/main.go", false, true)
				local dirs = {}
				for _, f in ipairs(mains) do
					if not f:match("/vendor/") then
						dirs[#dirs + 1] = vim.fn.fnamemodify(f, ":h")
					end
				end
				if #dirs == 0 then
					return require("dap").ABORT
				elseif #dirs == 1 then
					return dirs[1]
				end
				-- nvim-dap runs program functions inside a coroutine, so we can
				-- yield here and resume once vim.ui.select calls back.
				local co = coroutine.running()
				vim.ui.select(dirs, {
					prompt = "Debug which main package?",
					format_item = function(d) return vim.fn.fnamemodify(d, ":.") end,
				}, function(choice)
					coroutine.resume(co, choice)
				end)
				local choice = coroutine.yield()
				return choice or require("dap").ABORT
			end

			-- Named launch presets. Each entry is its own pickable config at
			-- dap.continue, so the arg sets you use often live here as a menu
			-- instead of being retyped. Add a new preset by copying a block
			-- and giving it a name + args.
			dap.configurations.go = dap.configurations.go or {}
			vim.list_extend(dap.configurations.go, {
				{
					-- auto-finds main.go (root, cmd/main.go, cmd/<app>/main.go);
					-- prompts to pick when there's more than one. cwd is the
					-- module root so relative paths resolve correctly.
					type = "go",
					name = "Debug main",
					request = "launch",
					program = pick_program,
					cwd = module_root,
					env = { CGO_ENABLED = "0", NO_COLOR = "1" },
					stopOnEntry = false,
					outputMode = "remote",
				},
				{
					-- Prompt for env vars as "KEY=val FOO=bar" — useful for
					-- API keys, feature flags, DSNs without touching .env files.
					type = "go",
					name = "Debug main + env",
					request = "launch",
					program = pick_program,
					cwd = module_root,
					env = prompt_env("go-env"),
					stopOnEntry = false,
					outputMode = "remote",
				},
				{
					-- Prompt for build flags — useful for "-tags integration",
					-- "-tags debug", etc. without changing go.mod or Makefile.
					type = "go",
					name = "Debug main + build flags",
					request = "launch",
					program = pick_program,
					cwd = module_root,
					buildFlags = prompt_string("go-buildflags", "Build flags (-tags foo)"),
					stopOnEntry = false,
					outputMode = "remote",
				},
			})

			-- Compose launch: type "./cmd/server -- --port 8080" in one prompt.
			-- Everything before " -- " is the program; everything after is args.
			-- Persists last value so re-running needs just <Enter>.
			vim.keymap.set("n", "<leader>DC", function()
				local history = load_args()
				local prev = history["go-compose"] or "./"
				local input = vim.fn.input({ prompt = "dlv> ", default = prev })
				local trimmed = vim.trim(input)
				if trimmed == "" then return end
				history["go-compose"] = trimmed
				save_args(history)

				local program, args
				local sep = trimmed:find(" %-%- ")
				if sep then
					program = vim.trim(trimmed:sub(1, sep - 1))
					args = require("dap.utils").splitstr(vim.trim(trimmed:sub(sep + 4)))
				else
					program = trimmed
					args = nil
				end

				dap.run({
					type = "go",
					request = "launch",
					name = "Debug (compose)",
					program = program,
					cwd = module_root(),
					args = args,
					env = { CGO_ENABLED = "0", NO_COLOR = "1" },
					stopOnEntry = false,
					outputMode = "remote",
				})
			end, { desc = "Debug compose (./program -- args)" })

			-- breakpoints
			vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>DB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "Conditional breakpoint" })
			vim.keymap.set("n", "<leader>Dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
			end, { desc = "Log point" })

			-- execution
			vim.keymap.set("n", "<leader>Dc", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<leader>Ds", dap.step_over, { desc = "Step over" })
			vim.keymap.set("n", "<leader>Di", dap.step_into, { desc = "Step into" })
			vim.keymap.set("n", "<leader>Do", dap.step_out, { desc = "Step out" })
			vim.keymap.set("n", "<leader>DR", dap.restart, { desc = "Restart" })
			vim.keymap.set("n", "<leader>Dr", dap.run_last, { desc = "Run last" })
			vim.keymap.set("n", "<leader>Dq", dap.terminate, { desc = "Quit" })

			-- ui
			vim.keymap.set("n", "<leader>Du", function()
				require("dapui").toggle()
			end, { desc = "Toggle UI" })
			vim.keymap.set({ "n", "v" }, "<leader>De", function()
				require("dapui").eval()
			end, { desc = "Eval expression" })

			-- go-specific
			vim.keymap.set("n", "<leader>Dt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug test (Go)" })
			vim.keymap.set("n", "<leader>DT", function()
				require("dap-go").debug_last_test()
			end, { desc = "Debug last test (Go)" })
		end,
	},
}
