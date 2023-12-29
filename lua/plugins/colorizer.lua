local M = {}

function M.config()
    require("colorizer").setup({
        filetypes = { "html", "css", "javascript", "vim", "lua", "sh", "zsh" },
        user_default_options = {
            css = true,
            mode = "virtualtext",
            virtualtext = "󰹞󰹞󰹞",
        },
    })
end

return M
