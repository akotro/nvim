local M = {}

M.dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons",
}

M.opts = {
    latex = {
        -- Whether LaTeX should be rendered, mainly used for health check
        enabled = false,
    },
    -- NOTE: Uncomment to get inline latex rendering (doesn't work that well)
    -- win_options = { conceallevel = { rendered = 2 } },
    -- on = {
    --     attach = function()
    --         require("nabla").enable_virt({ autogen = true })
    --     end,
    -- },
}

return M
