local M = {}

M.setup = function()
    local opts = {
        map_char = {
            all = "(",
            tex = "{",
        },
        ---@usage check bracket in same line
        enable_check_bracket_line = false,
        ---@usage check treesitter
        check_ts = true,
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
            java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
        enable_moveright = true,
        ---@usage disable when recording or executing a macro
        disable_in_macro = false,
        ---@usage add bracket pairs after quote
        enable_afterquote = true,
        ---@usage map the <BS> key
        map_bs = true,
        ---@usage map <c-w> to delete a pair if possible
        map_c_w = false,
        ---@usage disable when insert after visual block mode
        disable_in_visualblock = false,
        ---@usage  change default fast_wrap
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
            offset = 0, -- Offset from pattern match
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "Search",
            highlight_grey = "Comment",
        },
    }

    local status_ok, autopairs = pcall(require, "nvim-autopairs")
    if not status_ok then
        return
    end

    autopairs.setup({
        check_ts = opts.check_ts,
        enable_check_bracket_line = opts.enable_check_bracket_line,
        ts_config = opts.ts_config,
        disable_filetype = opts.disable_filetype,
        disable_in_macro = opts.disable_in_macro,
        ignored_next_char = opts.ignored_next_char,
        enable_moveright = opts.enable_moveright,
        enable_afterquote = opts.enable_afterquote,
        map_c_w = opts.map_c_w,
        map_bs = opts.map_bs,
        disable_in_visualblock = opts.disable_in_visualblock,
        fast_wrap = opts.fast_wrap,
    })

    pcall(function()
        local function on_confirm_done(...)
            require("nvim-autopairs.completion.cmp").on_confirm_done()(...)
        end
        require("cmp").event:off("confirm_done", on_confirm_done)
        require("cmp").event:on("confirm_done", on_confirm_done)
    end)
end

return M
