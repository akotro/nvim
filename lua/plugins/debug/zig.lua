local M = {}

M.setup = function()
    local dap = require("dap")

    dap.configurations.zig = {
        {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
        },
    }
end

return M
