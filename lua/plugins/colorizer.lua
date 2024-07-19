local M = {}

function M.config()
    require("colorizer").setup({
        user_default_options = {
            names = false,
            css = true,
            mode = "virtualtext",
            -- virtualtext = "󰹞󰹞󰹞",
        },
    })
end

return M
