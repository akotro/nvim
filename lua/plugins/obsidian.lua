local M = {}

M.dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter",
}

M.opts = {
    workspaces = {
        {
            name = "obsidian",
            path = "~/obsidian",
        },
    },
}

M.keys = {
    ["gf"] = {
        action = function()
            return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
    },
    ["<leader>ch"] = {
        action = function()
            return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
    },
    {
        "<leader>nf",
        "<cmd>ObsidianQuickSwitch<cr>",
        { buffer = true },
    },
}

return M
