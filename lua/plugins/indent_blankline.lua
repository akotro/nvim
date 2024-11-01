local M = {}

local icons = require("config.ui").icons

M.opts = {
    -- NOTE: Commented due to https://github.com/lukas-reineke/indent-blankline.nvim/issues/936
    -- indent = {
    --     char = icons.ui.LineLeft,
    --     tab_char = icons.ui.LineLeft,
    -- },
    -- scope = {
    --     enabled = false,
    --     char = icons.ui.LineLeft,
    -- },
    exclude = {
        buftypes = { "terminal", "nofile" },
        filetypes = {
            "help",
            "startify",
            "dashboard",
            "lazy",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "text",
            "neorg",
            "oil",
        },
    },
}

return M
