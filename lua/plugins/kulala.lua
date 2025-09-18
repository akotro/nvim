local M = {}

---@module "kulala"

M.keys = {
    { "<leader>c", "", desc = "+Rest" },
    {
        "<leader>cb",
        function()
            require("kulala").scratchpad()
        end,
        desc = "Open scratchpad",
    },
    {
        "<leader>cc",
        function()
            require("kulala").copy()
        end,
        desc = "Copy as cURL",
    },
    {
        "<leader>cC",
        function()
            require("kulala").from_curl()
        end,
        desc = "Paste from curl",
    },
    {
        "<leader>cg",
        function()
            require("kulala").download_graphql_schema()
        end,
        desc = "Download GraphQL schema",
    },
    {
        "<leader>ci",
        function()
            require("kulala").inspect()
        end,
        desc = "Inspect current request",
    },
    {
        "<leader>cn",
        function()
            require("kulala").jump_next()
        end,
        desc = "Jump to next request",
    },
    {
        "<leader>cp",
        function()
            require("kulala").jump_prev()
        end,
        desc = "Jump to previous request",
    },
    {
        "<leader>cq",
        function()
            require("kulala").close()
        end,
        desc = "Close window",
    },
    {
        "<leader>cr",
        function()
            require("kulala").replay()
        end,
        desc = "Replay the last request",
    },
    {
        "<leader>cs",
        function()
            require("kulala").run()
        end,
        desc = "Send the request",
    },
    {
        "<leader>cS",
        function()
            require("kulala").show_stats()
        end,
        desc = "Show stats",
    },
    {
        "<leader>ct",
        function()
            require("kulala").toggle_view()
        end,
        desc = "Toggle headers/body",
    },
    {
        "<leader>cu",
        function()
            require("lua.kulala.ui.auth_manager").open_auth_config()
        end,
        desc = "Manage Auth Config",
    },
    {
        "<leader>ce",
        function()
            require("kulala").set_selected_env()
        end,
        desc = "Select environment",
    },
}

M.opts = {
    lsp = {
        formatter = true,
    },
}

return M
