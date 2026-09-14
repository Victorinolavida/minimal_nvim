return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "leoluz/nvim-dap-go",

        "theHamsta/nvim-dap-virtual-text",

        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "rcarriga/nvim-dap-ui",
    },
    keys = {
        -- Debugger
        {
            "<leader>D",
            group = "Debugger",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Dt",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Dc",
            function()
                require("dap").continue()
            end,
            desc = "Continue",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Di",
            function()
                require("dap").step_into()
            end,
            desc = "Step Into",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Do",
            function()
                require("dap").step_over()
            end,
            desc = "Step Over",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Du",
            function()
                require("dap").step_out()
            end,
            desc = "Step Out",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Dr",
            function()
                require("dap").repl.open()
            end,
            desc = "Open REPL",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Dl",
            function()
                require("dap").run_last()
            end,
            desc = "Run Last",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Dq",
            function()
                require("dap").terminate()
                require("dapui").close()
                require("nvim-dap-virtual-text").toggle()
            end,
            desc = "Terminate",
            nowait = true,
            remap = false,
        },
        {
            "<leader>Db",
            function()
                require("dap").list_breakpoints()
            end,
            desc = "List Breakpoints",
            nowait = true,
            remap = false,
        },
        {
            "<leader>De",
            function()
                require("dap").set_exception_breakpoints({ "all" })
            end,
            desc = "Set Exception Breakpoints",
            nowait = true,
            remap = false,
        },
    },

    config = function()
        local mason_dap = require("mason-nvim-dap")
        local dap = require("dap")
        local ui = require("dapui")
        local dap_virtual_text = require("nvim-dap-virtual-text")

        -- Dap virtual text
        dap_virtual_text.setup {}


        mason_dap.setup({
            ensure_installed = { "delve" },
            automatic_installation = true,
            handlers = {
                function(cfg)
                    require("mason-nvim-dap").default_setup(cfg)
                end
            }
        })

        dap.configurations = {
            go = {
                {
                    type = "delve",
                    name = "Debug",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "delve",
                    name = "Debug test", -- configuration for debugging test files
                    request = "launch",
                    mode = "test",
                    program = "${file}",
                },
                -- works with go.mod packages and sub packages
                {
                    type = "delve",
                    name = "Debug test (go.mod)",
                    request = "launch",
                    mode = "test",
                    program = "./${relativeFileDirname}",
                },
            },
        }

        -- Dap ui
        ui.setup {}
        vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end
    end
}
