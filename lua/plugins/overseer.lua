local M = {}

M.keys = {
    {
        "<leader>R",
        "<cmd>OverseerRun<cr>",
        desc = "OverseerRun",
    },
    {
        "<leader>Br",
        "<cmd>OverseerRun<cr>",
        desc = "OverseerRun",
    },
    {
        "<leader>Bt",
        "<cmd>OverseerToggle<cr>",
        desc = "OverseerToggle",
    },
    {
        "<leader>Bl",
        "<cmd>OverseerRestartLast<cr>",
        desc = "OverseerRestartLast",
    },
}

M.opts = {
    strategy = { "toggleterm", close_on_exit = false },
}

function M.config(_, opts)
    require("overseer").setup(opts)

    vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, {})
end

return M
