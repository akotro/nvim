local M = {}

M.keys = {
    -- {
    -- 	"<S-Enter>",
    -- 	function()
    -- 		require("noice").redirect(vim.fn.getcmdline())
    -- 	end,
    -- 	mode = "c",
    -- 	desc = "Redirect Cmdline",
    -- },
    {
        "<leader>Nl",
        function()
            require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
    },
    {
        "<leader>Nh",
        function()
            require("noice").cmd("history")
        end,
        desc = "Noice History",
    },
    {
        "<leader>Na",
        function()
            require("noice").cmd("all")
        end,
        desc = "Noice All",
    },
    {
        "<leader>Nd",
        function()
            require("noice").cmd("dismiss")
        end,
        desc = "Noice Dismiss All",
    },
    {
        "<c-f>",
        function()
            if not require("noice.lsp").scroll(4) then
                return "<c-f>"
            end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
    },
    {
        "<c-b>",
        function()
            if not require("noice.lsp").scroll(-4) then
                return "<c-b>"
            end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
    },
}

M.opts = {
    messages = {
        enabled = true,
        view = "mini", -- default view for messages
        view_error = "mini", -- view for errors
        view_warn = "mini", -- view for warnings
        view_search = false,
    },
    lsp = {
        progress = {
            enabled = false,
        },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                any = {
                    { find = "%d+L, %d+B" },
                    { find = "; after #%d+" },
                    { find = "; before #%d+" },
                },
            },
            view = "mini",
        },
        {
            filter = { event = "msg_showmode" },
            view = "notify",
        },
        -- NOTE: Disable Copilot enabled/disabled messages
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "Copilot",
            },
            opts = { skip = true },
        },
    },
    popupmenu = {
        -- backend = "cmp",
    },
    views = {
        mini = {
            position = {
                row = 2,
            },
            border = {
                style = "none",
            },
        },
    },
    presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
    },
}

function M.config()
    require("noice").setup(M.opts)
end

return M
