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
            overrides = function(colors)
                local theme = colors.theme
                return {
                    -- nvim-cmp
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        })
    end
end

return M
