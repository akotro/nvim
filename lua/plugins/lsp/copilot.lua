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
        filetypes = {
            markdown = true,
            latex = true,
        },
    })
end

return M
