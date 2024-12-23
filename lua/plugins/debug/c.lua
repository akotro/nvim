local M = {}

M.setup = function()
    local dap = require("dap")

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
end

return M
