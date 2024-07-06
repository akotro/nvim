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
    {
        "<leader>cpt",
        "<cmd>Copilot toggle<cr>",
        desc = "Copilot Toggle",
    },
}

function M.config()
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })
end

return M
