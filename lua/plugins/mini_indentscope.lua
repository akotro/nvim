local M = {}

function M.init()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })
end

M.opts = {
    symbol = require("config.ui").icons.ui.LineLeft,
    options = { try_as_border = true },
    draw = {
        delay = 50,
    },
}

return M
