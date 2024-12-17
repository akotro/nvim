local M = {}

---@module "snacks"

---@type snacks.Config
M.opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    -- notifier = {
    --     enabled = true,
    --     timeout = 3000,
    -- },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    indent = {
        filter = function(buf)
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
    },
    input = { enabled = true },
    -- scroll = { enabled = true },

    styles = {
        ---@diagnostic disable-next-line: missing-fields
        notification = {
            wo = { wrap = true }, -- Wrap notifications
        },
    },
}

M.keys = {
    {
        "<leader>.",
        function()
            Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
    },
    {
        "<leader>S",
        function()
            Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
    },
    -- {
    --     "<leader>uh",
    --     function()
    --         Snacks.notifier.show_history()
    --     end,
    --     desc = "Notification History",
    -- },
    -- {
    --     "<leader>un",
    --     function()
    --         Snacks.notifier.hide()
    --     end,
    --     desc = "Dismiss All Notifications",
    -- },
    {
        "<leader>bd",
        function()
            Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
    },
    {
        "<leader>cR",
        function()
            Snacks.rename.rename_file()
        end,
        desc = "Rename File",
    },
    {
        "<leader>gB",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Git Browse",
    },
    {
        "]]",
        function()
            Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
    },
    {
        "[[",
        function()
            Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
    },
    {
        "<leader>uN",
        desc = "Neovim News",
        function()
            ---@diagnostic disable-next-line: missing-fields
            Snacks.win({
                file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                width = 0.6,
                height = 0.6,
                wo = {
                    spell = false,
                    wrap = false,
                    signcolumn = "yes",
                    statuscolumn = " ",
                    conceallevel = 3,
                },
            })
        end,
    },
}

function M.init()
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
                Snacks.debug.inspect(...)
            end
            _G.bt = function()
                Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>Os")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>Ow")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>OL")
            Snacks.toggle.diagnostics():map("<leader>Od")
            Snacks.toggle.line_number():map("<leader>Ol")
            Snacks.toggle
                .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                :map("<leader>Oc")
            Snacks.toggle.treesitter():map("<leader>OT")
            Snacks.toggle
                .option("background", { off = "light", on = "dark", name = "Dark Background" })
                :map("<leader>Ob")
            Snacks.toggle.inlay_hints():map("<leader>Oh")
        end,
    })
end

return M
