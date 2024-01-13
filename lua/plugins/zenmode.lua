local M = {}

M.opts = {
    window = {
        options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
        },
    },
    plugins = {
        options = {
            laststatus = 0,
        },
    },
}

return M
