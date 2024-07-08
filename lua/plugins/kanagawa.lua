local M = {}

function M.config()
    local status, kanagawa = pcall(require, "kanagawa")
    if not status then
        vim.notify("Kanagawa not found", vim.log.levels.ERROR)
    else
        kanagawa.setup({
            compile = true,
            dimInactive = false,
            colors = {
                theme = { all = { ui = { bg_gutter = "none" } } },
            },
        })
        vim.cmd([[colorscheme kanagawa]])
    end
end

return M
