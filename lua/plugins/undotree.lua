local M = {}

M.cmd = {
    "UndotreeToggle",
    "UndotreeShow",
    "UndotreePersistUndo",
    "UndotreeHide",
}

M.keys = {
    {
        "<leader>uu",
        function()
            vim.api.nvim_command("UndotreeToggle")
        end,
        desc = "Undotree Toggle",
    },
}

M.config = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_ShortIndicators = 1
end

return M
