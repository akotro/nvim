local M = {}

M.dependencies = {
    "nvim-lua/plenary.nvim",
    -- "hrsh7th/nvim-cmp",
    -- "nvim-telescope/telescope.nvim",
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
        nvim_cmp = false, -- NOTE: see https://github.com/epwalsh/obsidian.nvim/issues/770
        -- Trigger completion at 2 chars.
        min_chars = 2,
    },

    -- Due to using markdown.nvim for this
    ui = { enable = false },
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
        "<leader>nc",
        function()
            require("obsidian").util.toggle_checkbox()
        end,
        { buffer = true },
        desc = "Toggle checkbox",
    },
    {
        "<leader>nn",
        "<cmd>ObsidianNew<cr>",
        { buffer = true },
        desc = "Obsidian new note",
    },
    {
        "<leader>nf",
        "<cmd>ObsidianQuickSwitch<cr>",
        { buffer = true },
        desc = "Obsidian find files",
    },
    {
        "<leader>nt",
        "<cmd>ObsidianTags<cr>",
        { buffer = true },
        desc = "Obsidian find tags",
    },
}

return M
