local M = {}

M.opts = {
    indent = {
        char = require("config.icons").ui.LineLeft,
        tab_char = require("config.icons").ui.LineLeft,
    },
    scope = {
        enabled = false,
        char = require("config.icons").ui.LineLeft,
    },
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
