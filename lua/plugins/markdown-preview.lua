local M = {}

M.build = function()
    vim.fn["mkdp#util#install"]()
end

return M
