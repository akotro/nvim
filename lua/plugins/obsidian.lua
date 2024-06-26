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

    completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
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
        "<cr>",
        function()
            require("obsidian").util.smart_action()
        end,
        { noremap = false, buffer = true },
    },
    {
        "<leader>nf",
        "<cmd>ObsidianQuickSwitch<cr>",
        { buffer = true },
    },
    {
        "<leader>nt",
        "<cmd>ObsidianTags<cr>",
        { buffer = true },
    },
}

return M
