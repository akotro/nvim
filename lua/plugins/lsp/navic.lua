local M = {}

M.dependencies = { "neovim/nvim-lspconfig" }

---@type Options
M.opts = {
    depth_limit = 2,
    lsp = {
        auto_attach = true,
    },
}

return M
