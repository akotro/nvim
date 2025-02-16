local M = {}

M.keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diff View Open" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
    {
        "<leader>gdh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Diff View File History (Current File)",
    },
}

return M
