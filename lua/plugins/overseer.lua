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
    dap = false,
    templates = { "builtin", "user.custom" },
}

function M.config(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    overseer.add_template_hook({ module = "^cargo$" }, function(task_defn, _)
        task_defn.env = vim.tbl_extend("force", task_defn.env or {}, {
            RUST_BACKTRACE = "1",
        })
    end)

    vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, {})
end

return M
