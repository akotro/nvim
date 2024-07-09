local M = {}

function M.config()
    require("colorizer").setup({
        user_default_options = {
            css = true,
            mode = "virtualtext",
            -- virtualtext = "󰹞󰹞󰹞",
        },
    })
end

return M
