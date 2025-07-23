local M = {}

---@module "kulala"

M.keys = {
    { "<leader>c", "", desc = "+Rest" },
    { "<leader>cb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad" },
    { "<leader>cc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
    { "<leader>cC", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from curl" },
    {
        "<leader>cg",
        "<cmd>lua require('kulala').download_graphql_schema()<cr>",
        desc = "Download GraphQL schema",
    },
    { "<leader>ci", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request" },
    { "<leader>cn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
    {
        "<leader>cp",
        "<cmd>lua require('kulala').jump_prev()<cr>",
        desc = "Jump to previous request",
    },
    { "<leader>cq", "<cmd>lua require('kulala').close()<cr>", desc = "Close window" },
    { "<leader>cr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay the last request" },
    { "<leader>cs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
    { "<leader>cS", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show stats" },
    { "<leader>ct", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
}

M.opts = {
    lsp = {
        formatter = true,
    },
}

M.init = function()
    vim.filetype.add({
        extension = {
            ["http"] = "http",
        },
    })
end

return M
