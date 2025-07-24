local M = {}

M.cmd = "Neogit"

M.dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
}

M.keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
}

return M
