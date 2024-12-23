local M = {}

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
            vim.fn.confirm("Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2)
            == 1
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

---@module "nvim-dap"
local dotnet_setup = function()
    local dap = require("dap")
    if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
            type = "executable",
            command = vim.fn.exepath("netcoredbg"),
            args = { "--interpreter=vscode" },
            -- console = "internalConsole",
        }
    end
    dap.configurations.cs = {
        {
            log_level = "DEBUG",
            type = "coreclr",
            -- type = "netcoredbg",
            justMyCode = false,
            stopAtEntry = false,
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
end

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
    local spinner = require("easy-dotnet.ui-modules.spinner").new()
    spinner:start_spinner("Building")
    vim.fn.jobstart(string.format("dotnet build %s", path), {
        on_exit = function(_, return_code)
            if return_code == 0 then
                spinner:stop_spinner("Built successfully")
            else
                spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                error("Build failed")
            end
            coroutine.resume(co)
        end,
    })
    coroutine.yield()
end

M.setup = function()
    local dap = require("dap")
    local dotnet = require("easy-dotnet")
    local debug_dll = nil

    local function ensure_dll()
        if debug_dll ~= nil then
            return debug_dll
        end
        local dll = dotnet.get_debug_dll()
        debug_dll = dll
        return dll
    end

    for _, value in ipairs({ "cs", "fsharp" }) do
        dap.configurations[value] = {
            {
                log_level = "DEBUG",
                type = "netcoredbg",
                justMyCode = false,
                stopAtEntry = false,
                name = "Default",
                request = "launch",
                env = function()
                    local dll = ensure_dll()
                    local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
                    return vars or nil
                end,
                program = function()
                    local dll = ensure_dll()
                    local co = coroutine.running()
                    rebuild_project(co, dll.project_path)
                    return dll.relative_dll_path
                end,
                cwd = function()
                    local dll = ensure_dll()
                    return dll.relative_project_path
                end,
            },
            {
                type = "coreclr",
                name = "Test",
                request = "attach",
                processId = function()
                    local res = require("easy-dotnet.debugger").start_debugging_test_project()
                    return res.process_id
                end,
            },
        }
    end

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
        debug_dll = nil
    end

    if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
            type = "executable",
            command = vim.fn.exepath("netcoredbg"),
            args = { "--interpreter=vscode" },
            -- console = "internalConsole",
        }
    end

    dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    }
end

return M
