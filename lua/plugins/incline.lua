local M = {}

M.dependencies = {
    "nvim-lualine/lualine.nvim",
}

function M.config()
    local devicons = require("nvim-web-devicons")
    local lualine_utils = require("lualine.utils.utils")
    local functions = require("config.functions")

    local active_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" }).fg
    local inactive_fg = vim.api.nvim_get_hl(0, { name = "lualine_c_inactive" }).fg
    local active_fg_color = active_fg and string.format("#%06X", active_fg)
    local inactive_fg_color = inactive_fg and string.format("#%06X", inactive_fg)

    local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })

    local inactive_bg_color = statusline_hl.bg and string.format("#%06X", statusline_hl.bg)

    require("incline").setup({
        window = {
            padding = 0,
            margin = { horizontal = 0 },
        },
        render = function(props)
            local bufname = vim.api.nvim_buf_get_name(props.buf)
            local filename =
                functions.filename_and_parent(vim.fn.fnamemodify(bufname, ":p:~"), package.config:sub(1, 1))
            if bufname == "" then
                filename = "[No Name]"
            end

            local is_active = props.focused

            local text_color = is_active and active_fg_color or inactive_fg_color
            local text_style = is_active and "bold" or ""

            local bg_color = is_active and "none" or inactive_bg_color

            local ft_icon, ft_icon_hl_group = devicons.get_icon(filename)
            local ft_color = lualine_utils.extract_highlight_colors(ft_icon_hl_group, "fg")
            local modified = vim.bo[props.buf].modified

            local decorations = is_active and "underline" or ""

            return {
                ft_icon and { " ", ft_icon, " ", guibg = bg_color, guifg = ft_color } or "",
                " ",
                {
                    filename,
                    gui = (modified and text_style .. ",italic" or text_style)
                        .. (decorations ~= "" and "," .. decorations or ""),
                    guifg = text_color,
                    guibg = bg_color,
                },
                " ",
                guibg = bg_color,
            }
        end,
    })
end

return M
