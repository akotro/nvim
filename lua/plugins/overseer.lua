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

    overseer.add_template_hook({ module = "builtin" }, function(task_defn, util)
        util.add_component(task_defn, { "on_output_quickfix", open = false })
        util.add_component(task_defn, { "on_result_diagnostics_trouble", close = true })
    end)

    overseer.add_template_hook({ module = "^cargo$" }, function(task_defn, util)
        util.add_component(task_defn, { "on_output_quickfix", open = false })
        task_defn.env = vim.tbl_extend("force", task_defn.env or {}, {
            RUST_BACKTRACE = "1",
        })
    end)

    overseer.add_template_hook({ module = "^dotnet$" }, function(task_defn, util)
        util.add_component(task_defn, {
            desc = "Show Spinner",
            -- Define parameters that can be passed in to the component
            -- The params passed in will match the params defined above
            constructor = function(params)
                local num = 0
                local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

                local notification = vim.notify(spinner_frames[1] .. " Building", "info", {
                    timeout = false,
                })

                local timer = vim.loop.new_timer()

                return {
                    on_init = function(self, task)
                        timer:start(
                            100,
                            100,
                            vim.schedule_wrap(function()
                                num = num + 1
                                local new_spinner = num % #spinner_frames
                                notification = vim.notify(
                                    spinner_frames[new_spinner + 1] .. " Building",
                                    "info",
                                    { replace = notification }
                                )
                            end)
                        )
                    end,
                    on_complete = function(self, task, code)
                        vim.notify("", "info", { replace = notification, timeout = 1 })
                        timer:stop()
                        return code
                    end,
                }
            end,
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
