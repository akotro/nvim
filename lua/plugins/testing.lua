local M = {}

M.keys = {
    {
        "<leader>Tt",
        function()
            require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
    },
    {
        "<leader>TT",
        function()
            require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files",
    },
    {
        "<leader>Tr",
        function()
            require("neotest").run.run()
        end,
        desc = "Run Nearest",
    },
    {
        "<leader>Ts",
        function()
            require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
    },
    {
        "<leader>To",
        function()
            require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
    },
    {
        "<leader>TO",
        function()
            require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
    },
    {
        "<leader>TS",
        function()
            require("neotest").run.stop()
        end,
        desc = "Stop",
    },
    {
        "<leader>Td",
        function()
            require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
    },
}

M.dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "Issafalcon/neotest-dotnet",
}

M.opts = {
    status = { virtual_text = true },
    output = { open_on_run = false },
    quickfix = {
        open = function()
            if require("config.functions").plugin.has("trouble.nvim") then
                require("trouble").open({ mode = "quickfix", focus = false })
            else
                vim.cmd("copen")
            end
        end,
    },
}

function M.config(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
        virtual_text = {
            format = function(diagnostic)
                -- Replace newline and tab characters with space for more compact diagnostics
                local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                return message
            end,
        },
    }, neotest_ns)

    if require("config.functions").plugin.has("trouble.nvim") then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        opts.consumers.trouble = function(client)
            client.listeners.results = function(adapter_id, results, partial)
                if partial then
                    return
                end
                local tree = assert(client:get_position(nil, { adapter = adapter_id }))

                local failed = 0
                for pos_id, result in pairs(results) do
                    if result.status == "failed" and tree:get_key(pos_id) then
                        failed = failed + 1
                    end
                end
                vim.schedule(function()
                    local trouble = require("trouble")
                    if trouble.is_open() then
                        trouble.refresh()
                        if failed == 0 then
                            trouble.close()
                        end
                    end
                end)
                return {}
            end
        end
    end

    opts.adapters = {
        require("rustaceanvim.neotest"),
        require("neotest-dotnet"),
    }

    require("neotest").setup(opts)
end

return M
