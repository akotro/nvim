local M = {}

function M.opts()
    local icons = require("config.ui").icons
    return {
        signs = {
            add = {
                text = icons.ui.BoldLineLeft,
            },
            change = {
                text = icons.ui.BoldLineLeft,
            },
            delete = {
                text = icons.ui.Triangle,
            },
            topdelete = {
                text = icons.ui.Triangle,
            },
            changedelete = {
                text = icons.ui.BoldLineLeft,
            },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            enable = true,
            follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        status_formatter = nil, -- Use default
        update_debounce = 200,
        max_file_length = 40000,
        preview_config = {
            -- Options passed to nvim_open_win
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    }
end

M.keys = {
    {
        "]g",
        function()
            require("gitsigns").nav_hunk("next")
        end,
        desc = "Git Next Hunk",
    },
    {
        "[g",
        function()
            require("gitsigns").nav_hunk("prev")
        end,
        desc = "Git Prev Hunk",
    },
    {
        "<leader>gB",
        function()
            require("gitsigns").blame_line()
        end,
        desc = "Git Blame Line",
    },
    {
        "<leader>gr",
        function()
            require("gitsigns").reset_hunk()
        end,
        desc = "Reset Hunk",
        nowait = true,
        remap = false,
    },
    {
        "<leader>gR",
        function()
            require("gitsigns").reset_buffer()
        end,
        desc = "Reset Buffer",
    },
}

return M
