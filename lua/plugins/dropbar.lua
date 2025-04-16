local M = {}

function M.config()
    local sources = require("dropbar.sources")
    local utils = require("dropbar.utils")

    local winfocus_fallback_source = {
        get_symbols = function(buf, win, cursor)
            if vim.api.nvim_get_current_win() == win then
                return utils.source.fallback({ sources.lsp, sources.treesitter }).get_symbols(buf, win, cursor)
            end
            return {}
        end,
    }

    require("dropbar").setup({
        sources = {
            lsp = {
                max_depth = 4,
            },
            treesitter = {
                max_depth = 4,
            },
        },
        bar = {
            update_debounce = 0,
            update_events = {
                win = {
                    "CursorMoved",
                    -- "WinEnter",
                    "WinResized",
                },
            },
            sources = function(buf)
                if vim.bo[buf].ft == "markdown" then
                    return {
                        sources.path,
                        sources.markdown,
                    }
                end
                if vim.bo[buf].buftype == "terminal" then
                    return {
                        sources.terminal,
                    }
                end
                return {
                    sources.path,
                    winfocus_fallback_source,
                }
            end,
        },
    })

    local active_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" }).fg
    local inactive_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_inactive" }).fg
    local active_fg_color = active_fg and string.format("#%06X", active_fg)
    local inactive_fg_color = inactive_fg and string.format("#%06X", inactive_fg)
    local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
    local inactive_bg_color = statusline_hl.bg and string.format("#%06X", statusline_hl.bg)
    local active_bold = true

    vim.api.nvim_set_hl(0, "WinBar", {
        fg = active_fg_color,
        bg = inactive_bg_color,
        bold = active_bold,
    })

    vim.api.nvim_set_hl(0, "WinBarNC", {
        fg = inactive_fg_color,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("WinBarHighlights", { clear = true }),
        callback = function()
            active_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" }).fg
            inactive_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_inactive" }).fg
            active_fg_color = active_fg and string.format("#%06X", active_fg)
            inactive_fg_color = inactive_fg and string.format("#%06X", inactive_fg)
            statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
            inactive_bg_color = statusline_hl.bg and string.format("#%06X", statusline_hl.bg)

            vim.api.nvim_set_hl(0, "WinBar", {
                fg = active_fg_color,
                bg = inactive_bg_color,
                bold = active_bold,
            })

            vim.api.nvim_set_hl(0, "WinBarNC", {
                fg = inactive_fg_color,
            })
        end,
    })

    vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = vim.api.nvim_create_augroup("DropbarWinFocus", { clear = true }),
        callback = function()
            if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].winbar == 1 then
                utils.bar.exec("update")
            end
        end,
    })
end

return M
