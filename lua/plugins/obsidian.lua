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
    {
        "gf",
        function()
            require("obsidian").util.gf_passthrough()
        end,
        { noremap = false, expr = true, buffer = true },
    },
    {
        "<leader>ch",
        function()
            require("obsidian").util.toggle_checkbox()
        end,
        { buffer = true },
    },
    {
        "<enter>",
        "<cmd>ObsidianFollowLink<cr>",
        { noremap = false, buffer = true },
    },
    {
        "<leader>nf",
        "<cmd>ObsidianQuickSwitch<cr>",
        { buffer = true },
    },
}

return M
