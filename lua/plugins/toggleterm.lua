local M = {}

M.keys = {
    {
        "<c-\\>",
        [[<cmd>exe v:count1 . "ToggleTerm"<cr>]],
        desc = "Toggle Terminal",
        mode = "",
    },
    {
        "<leader>to",
        "<cmd>ToggleTerm<cr>",
        desc = "Toggle Terminal",
    },
    {
        "<leader>tf",
        [[<cmd>exe v:count1 . "ToggleTerm direction='float'"<cr>]],
        desc = "Toggle Floating Terminal",
    },
    {
        "<leader>th",
        [[<cmd>exe v:count1 . "ToggleTerm direction='horizontal'"<cr>]],
        desc = "Toggle Horizontal Terminal",
    },
    {
        "<leader>tv",
        [[<cmd>exe v:count1 . "ToggleTerm direction='vertical'"<cr>]],
        desc = "Toggle Vertical Terminal",
    },
}

M.opts = {
    size = function(term)
        if term.direction == "horizontal" then
            return 20
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    start_in_insert = false,
    -- open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    },
}

return M
