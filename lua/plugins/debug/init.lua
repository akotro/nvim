local M = {}

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end

M.dependencies = {
    -- fancy UI for the debugger
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle({})
                end,
                desc = "Dap UI",
            },
            {
                "<leader>de",
                function()
                    -- call this twice to open and jump into the window
                    require("dapui").eval()
                    require("dapui").eval()
                end,
                desc = "Eval",
                mode = { "n", "v" },
            },
        },
        opts = {},
        config = function(_, opts)
            -- setup dap config by VsCode launch.json file
            -- require("dap.ext.vscode").load_launchjs()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },

    -- virtual text for the debugger
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },

    -- mason.nvim integration
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "codelldb",
                "coreclr",
                "netcoredbg",
            },
        },
    },

    -- lua adapter
    {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
            {
                "<leader>dL",
                function()
                    require("osv").launch({ port = 8086 })
                end,
                desc = "Launch Lua adapter",
            },
        },
    },
}

M.keys = {
    {
        "<leader>dB",
        function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
    },
    {
        "<leader>db",
        function()
            require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
    },
    {
        "<F9>",
        function()
            require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
    },
    {
        "<leader>dc",
        function()
            require("dap").continue()
        end,
        desc = "Continue",
    },
    {
        "<F5>",
        function()
            require("dap").continue()
        end,
        desc = "Continue",
    },
    {
        "<leader>da",
        function()
            require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
    },
    {
        "<leader>dC",
        function()
            require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
    },
    {
        "<C-F10>",
        function()
            require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
    },
    {
        "<leader>dg",
        function()
            require("dap").goto_()
        end,
        desc = "Goto to cursor (skip)",
    },
    {
        "<leader>di",
        function()
            require("dap").step_into()
        end,
        desc = "Step Into",
    },
    {
        "<F11>",
        function()
            require("dap").step_into()
        end,
        desc = "Step Into",
    },
    {
        "<leader>dj",
        function()
            require("dap").down()
        end,
        desc = "Down",
    },
    {
        "<leader>dk",
        function()
            require("dap").up()
        end,
        desc = "Up",
    },
    {
        "<leader>dl",
        function()
            require("dap").run_last()
        end,
        desc = "Run Last",
    },
    {
        "<leader>dO",
        function()
            require("dap").step_out()
        end,
        desc = "Step Out",
    },
    {
        "<S-F11>",
        function()
            require("dap").step_out()
        end,
        desc = "Step Out",
    },
    {
        "<leader>do",
        function()
            require("dap").step_over()
        end,
        desc = "Step Over",
    },
    {
        "<F10>",
        function()
            require("dap").step_over()
        end,
        desc = "Step Over",
    },
    {
        "<leader>dp",
        function()
            require("dap").pause()
        end,
        desc = "Pause",
    },
    {
        "<leader>dr",
        function()
            require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
    },
    {
        "<leader>ds",
        function()
            require("dap").session()
        end,
        desc = "Session",
    },
    {
        "<leader>dt",
        function()
            require("dap").terminate()
            require("dapui").close({})
        end,
        desc = "Terminate",
    },
    {
        "<S-F5>",
        function()
            require("dap").terminate()
            require("dapui").close({})
        end,
        desc = "Terminate",
    },
    {
        "<leader>dw",
        function()
            require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
    },
}

function M.config()
    local utils = require("config.functions")
    local icons = require("config.ui").icons

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
            "Dap" .. name,
            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
    end

    local dap = require("dap")

    -- csharp
    local dotnet_build_project = function()
        local default_path = vim.fn.getcwd() .. "/"
        if vim.g["dotnet_last_proj_path"] ~= nil then
            default_path = vim.g["dotnet_last_proj_path"]
        end
        local path = vim.fn.input("Path to your *proj file", default_path, "file")
        vim.g["dotnet_last_proj_path"] = path
        local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
        print("")
        print("Cmd to execute: " .. cmd)
        local f = os.execute(cmd)
        if f == 0 then
            print("\nBuild: ✔️ ")
        else
            print("\nBuild: ❌ (code: " .. f .. ")")
        end
    end

    local dotnet_get_dll_path = function()
        local request = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end

        if vim.g["dotnet_last_dll_path"] == nil then
            vim.g["dotnet_last_dll_path"] = request()
        else
            if
                vim.fn.confirm(
                    "Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"],
                    "&yes\n&no",
                    2
                ) == 1
            then
                vim.g["dotnet_last_dll_path"] = request()
            end
        end

        return vim.g["dotnet_last_dll_path"]
    end

    local dotnet_get_workspace_path = function()
        local request = function()
            return vim.fn.input("Workspace folder: ", vim.fn.getcwd() .. "/", "file")
        end
        if vim.g["dotnet_last_workspace_path"] == nil then
            vim.g["dotnet_last_workspace_path"] = request()
        else
            if
                vim.fn.confirm(
                    "Do you want to change the workspace folder?\n" .. vim.g["dotnet_last_workspace_path"],
                    "&yes\n&no",
                    2
                ) == 1
            then
                vim.g["dotnet_last_workspace_path"] = request()
            end
        end

        return vim.g["dotnet_last_workspace_path"]
    end
    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            env = "ASPNETCORE_ENVIRONMENT=Development",
            args = {
                "--environment=Development",
            },
            program = function()
                if vim.fn.confirm("Recompile first?", "&yes\n&no", 2) == 1 then
                    dotnet_build_project()
                end
                return dotnet_get_dll_path()
            end,
            cwd = function()
                return dotnet_get_workspace_path()
            end,
        },
    }

    -- c, c++
    for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
            {
                type = "codelldb",
                request = "launch",
                name = "Launch file",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
            },
            {
                type = "codelldb",
                request = "attach",
                name = "Attach to process",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }
    end

    -- lua
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
        },
    }
    dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    if utils.plugin.has("overseer.nvim") then
        require("overseer").enable_dap()
    end
end

return M
