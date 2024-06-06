local M = {}

function M.config()
    local icons = require("config.ui").icons
    require("nvim-lightbulb").setup({
        sign = {
            enabled = false,
            priority = 10,
        },
        virtual_text = {
            enabled = true,
            -- text = " ",
            text = icons.ui.Lightbulb,
            hl_mode = "combine",
        },
        status_text = {
            enabled = false,
            -- text = "",
            icons.ui.Lightbulb,
            text_unavailable = "",
        },
        autocmd = {
            enabled = true,
            pattern = { "*" },
            events = { "CursorHold", "CursorHoldI" },
        },
    })
end

return M
