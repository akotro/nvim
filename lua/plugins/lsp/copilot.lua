local M = {}

M.keys = {
    {
        "<leader>cpe",
        "<cmd>Copilot enable<cr>",
        desc = "Copilot Enable",
    },
    {
        "<leader>cpd",
        "<cmd>Copilot disable<cr>",
        desc = "Copilot Disable",
    },
}

function M.config()
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })
    -- TODO: find a way to do this without message
    -- vim.cmd("silent! Copilot disable")
end

return M
