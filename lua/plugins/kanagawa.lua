local M = {}

function M.config()
    local status, kanagawa = pcall(require, "kanagawa")
    if not status then
        vim.notify("Kanagawa not found", vim.log.levels.ERROR)
    else
        kanagawa.setup({
            compile = true,
            keywordStyle = { italic = false, bold = true },
            dimInactive = false,
            colors = {
                theme = { all = { ui = { bg_gutter = "none" } } },
            },
        })
        vim.api.nvim_command("colorscheme kanagawa")
    end
end

return M
