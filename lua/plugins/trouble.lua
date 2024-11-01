local M = {}

local function navigateTrouble(direction)
    if require("trouble").is_open() then
        require("trouble")[direction]()
        require("trouble").jump()
    else
        local ok, err = pcall(vim.cmd["c" .. direction])
        if not ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end
end

function M.lspGoTo(mode)
    require("trouble").open({ mode = mode, auto_close = true, auto_jump = true })
end

M.keys = {
    {
        "<leader>xx",
        function()
            local last_mode = require("trouble").last_mode
            if last_mode == nil or last_mode == "" then
                require("trouble").toggle("diagnostics")
            else
                require("trouble").toggle(last_mode)
            end
        end,
        desc = "Toggle Last Mode (Trouble)",
    },
    {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
    },
    {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
    },
    {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=true win.position=left<cr>",
        desc = "Symbols (Trouble)",
    },
    {
        "<leader>xr",
        "<cmd>Trouble lsp toggle focus=false<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
    },
    {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
    },
    {
        "[q",
        function()
            navigateTrouble("prev")
        end,
        desc = "Previous trouble/quickfix item",
    },
    {
        "]q",
        function()
            navigateTrouble("next")
        end,
        desc = "Next trouble/quickfix item",
    },
}

M.opts = {
    auto_refresh = false,
}

return M
