local icons = require("config.ui").icons
local utils = require("config.functions")

local M = {}

M.cmd = "WhichKey"

local options = {
    setup = {
        plugins = {
            marks = false, -- shows a list of your marks on ' and `
            registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true,
                suggestions = 20,
            }, -- use which-key for spelling hints
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = false, -- adds help for operators like d, y, ...
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = false, -- default bindings on <c-w>
                nav = false, -- misc bindings to work with windows
                z = false, -- bindings for folds, spelling and others prefixed with z
                g = false, -- bindings for prefixed with g
            },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        key_labels = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            -- ["<space>"] = "SPC",
            -- ["<cr>"] = "RET",
            -- ["<tab>"] = "TAB",
        },
        icons = {
            breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
            separator = icons.ui.BoldArrowRight, -- symbol used between a key and it's label
            group = icons.ui.Plus, -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },
        window = {
            border = "single", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
            padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
            winblend = 0,
        },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        show_keys = true, -- show the currently pressed key and its label as a message in the command line
        triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            -- this is mostly relevant for key maps that start with a native binding
            -- most people should not need to change this
            i = { "j", "k" },
            v = { "j", "k" },
        },
        -- disable the WhichKey popup for certain buf types and file types.
        -- Disabled by default for Telescope
        disable = {
            buftypes = {},
            filetypes = { "TelescopePrompt", "snacks_picker_input" },
        },
    },

    -- opts = {
    --     mode = "n", -- NORMAL mode
    --     prefix = "<leader>",
    --     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    --     silent = true, -- use `silent` when creating keymaps
    --     noremap = true, -- use `noremap` when creating keymaps
    --     nowait = true, -- use `nowait` when creating keymaps
    -- },
    -- vopts = {
    --     mode = "v", -- VISUAL mode
    --     prefix = "<leader>",
    --     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    --     silent = true, -- use `silent` when creating keymaps
    --     noremap = true, -- use `noremap` when creating keymaps
    --     nowait = true, -- use `nowait` when creating keymaps
    -- },
    -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    mappings = {
        { "<leader>w", "<cmd>w<cr>", desc = "Save", nowait = true, remap = false },
        {
            "<leader>q",
            function()
                utils.smart_quit()
            end,
            desc = "Quit",
            nowait = true,
            remap = false,
        },
        {
            "<leader>/",
            function()
                require("Comment.api").toggle.linewise.current()
            end,
            desc = "Comment",
            nowait = true,
            remap = false,
        },
        { "<leader><space>", ":nohlsearch<cr>", desc = "Clear Highlight", nowait = true, remap = false },

        { "<leader>O", group = "Options", nowait = true, remap = false },

        { "<leader>T", group = "Test", nowait = true, remap = false },

        { "<leader>b", group = "Buffers", nowait = true, remap = false },
        {
            "<leader>bD",
            function()
                utils.delete_empty_buffers()
            end,
            desc = "Delete all empty buffers",
            nowait = true,
            remap = false,
        },
        -- {
        --     "<leader>bd",
        --     "<cmd>BufferLinePickClose<cr>",
        --     desc = "Pick which buffer to close",
        --     nowait = true,
        --     remap = false,
        -- },
        -- { "<leader>bf", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Find", nowait = true, remap = false },
        { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left", nowait = true, remap = false },
        { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump", nowait = true, remap = false },
        {
            "<leader>bl",
            "<cmd>BufferLineCloseRight<cr>",
            desc = "Close all to the right",
            nowait = true,
            remap = false,
        },
        { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next", nowait = true, remap = false },
        { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous", nowait = true, remap = false },
        {
            "<leader>bsd",
            "<cmd>BufferLineSortByDirectory<cr>",
            desc = "Sort by directory",
            nowait = true,
            remap = false,
        },
        {
            "<leader>bsl",
            "<cmd>BufferLineSortByExtension<cr>",
            desc = "Sort by language",
            nowait = true,
            remap = false,
        },

        { "<leader>d", group = "Debug", nowait = true, remap = false },

        { "<leader>f", group = "Find", nowait = true, remap = false },

        { "<leader>g", group = "Git", nowait = true, remap = false },
        { "<leader>gd", group = "Diff", nowait = true, remap = false },

        { "<leader>l", group = "LSP", nowait = true, remap = false },

        { "<leader>n", group = "Noice", nowait = true, remap = false },

        { "<leader>o", desc = "+Window", nowait = true, remap = false },
        {
            "<leader>of",
            function()
                utils.focus_first_float()
            end,
            desc = "Focus Floating Window",
            nowait = true,
            remap = false,
        },
        { "<leader>on", "<cmd>only<cr>", desc = "Focus This Window", nowait = true, remap = false },

        { "<leader>p", group = "Plugins", nowait = true, remap = false },
        { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install", nowait = true, remap = false },
        { "<leader>pl", "<cmd>Lazy<cr>", desc = "Lazy", nowait = true, remap = false },
        { "<leader>pr", "<cmd>Lazy restore<cr>", desc = "Restore", nowait = true, remap = false },
        { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync", nowait = true, remap = false },
        { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update", nowait = true, remap = false },
        { "<leader>px", "<cmd>Lazy clean<cr>", desc = "Clean", nowait = true, remap = false },

        { "<leader>r", group = "Replace", nowait = true, remap = false },
        { "<leader>ra", group = "[a]sk", nowait = true, remap = false },
        {
            "<leader>raW",
            function()
                utils.search.cWORD(false, false)
            end,
            desc = "[W]ORD",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rae",
            function()
                utils.search.cexpr(false, false)
            end,
            desc = "[e]xpr",
            nowait = true,
            remap = false,
        },
        {
            "<leader>raf",
            function()
                utils.search.cfile(false, false)
            end,
            desc = "[f]ile",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rao",
            function()
                utils.search.open(false, false)
            end,
            desc = "[o]pen",
            nowait = true,
            remap = false,
        },
        {
            "<leader>raw",
            function()
                utils.search.cword(false, false)
            end,
            desc = "[w]ord",
            nowait = true,
            remap = false,
        },
        { "<leader>rg", group = "[g]lobal", nowait = true, remap = false },
        { "<leader>rga", group = "[a]sk", nowait = true, remap = false },
        {
            "<leader>rgaW",
            function()
                utils.search.cWORD(true, false)
            end,
            desc = "[W]ORD",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgae",
            function()
                utils.search.cexpr(true, false)
            end,
            desc = "[e]xpr",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgaf",
            function()
                utils.search.cfile(true, false)
            end,
            desc = "[f]ile",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgao",
            function()
                utils.search.open(true, false)
            end,
            desc = "[o]pen",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgaw",
            function()
                utils.search.cword(true, false)
            end,
            desc = "[w]ord",
            nowait = true,
            remap = false,
        },
        { "<leader>rgn", group = "[n]o ask", nowait = true, remap = false },
        {
            "<leader>rgnW",
            function()
                utils.search.cWORD(true, true)
            end,
            desc = "[W]ORD",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgne",
            function()
                utils.search.cexpr(true, true)
            end,
            desc = "[e]xpr",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgnf",
            function()
                utils.search.cfile(true, true)
            end,
            desc = "[f]ile",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgno",
            function()
                utils.search.open(true, true)
            end,
            desc = "[o]pen",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rgnw",
            function()
                utils.search.cword(true, true)
            end,
            desc = "[w]ord",
            nowait = true,
            remap = false,
        },
        { "<leader>rn", group = "[n]o ask", nowait = true, remap = false },
        {
            "<leader>rnW",
            function()
                utils.search.cWORD(false, true)
            end,
            desc = "[W]ORD",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rne",
            function()
                utils.search.cexpr(false, true)
            end,
            desc = "[e]xpr",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rnf",
            function()
                utils.search.cfile(false, true)
            end,
            desc = "[f]ile",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rno",
            function()
                utils.search.open(false, true)
            end,
            desc = "[o]pen",
            nowait = true,
            remap = false,
        },
        {
            "<leader>rnw",
            function()
                utils.search.cword(false, true)
            end,
            desc = "[w]ord",
            nowait = true,
            remap = false,
        },

        { "<leader>s", group = "Split", nowait = true, remap = false },
        { "<leader>sh", "<cmd>leftabove vs<cr>", desc = "Left", nowait = true, remap = false },
        { "<leader>sj", "<cmd>rightbelow split<cr>", desc = "Down", nowait = true, remap = false },
        { "<leader>sk", "<cmd>leftabove split<cr>", desc = "Up", nowait = true, remap = false },
        { "<leader>sl", "<cmd>rightbelow vs<cr>", desc = "Right", nowait = true, remap = false },

        { "<leader>t", group = "Terminal", nowait = true, remap = false },

        { "<leader>x", group = "Trouble", nowait = true, remap = false },
        { "<leader>z", group = "Folds", nowait = true, remap = false },

        {
            mode = { "v" },
            {
                "<leader>/",
                function()
                    require("Comment.api").toggle.linewise.current()
                end,
                desc = "Comment toggle linewise (visual)",
                nowait = true,
                remap = false,
            },

            { "<leader>l", group = "LSP", nowait = true, remap = false },

            { "<leader>r", group = "Replace", nowait = true, remap = false },
            { "<leader>ra", group = "[a]sk", nowait = true, remap = false },
            {
                "<leader>raW",
                function()
                    utils.search.within_cWORD(false)
                end,
                desc = "[W]ORD",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rae",
                function()
                    utils.search.within_cexpr(false)
                end,
                desc = "[e]xpr",
                nowait = true,
                remap = false,
            },
            {
                "<leader>raf",
                function()
                    utils.search.within_cfile(false)
                end,
                desc = "[f]ile",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rao",
                function()
                    utils.search.within(false)
                end,
                desc = "[o]pen",
                nowait = true,
                remap = false,
            },
            {
                "<leader>raw",
                function()
                    utils.search.within_cword(false)
                end,
                desc = "[w]ord",
                nowait = true,
                remap = false,
            },
            { "<leader>rn", group = "[n]o ask", nowait = true, remap = false },
            {
                "<leader>rnW",
                function()
                    utils.search.within_cWORD(true)
                end,
                desc = "[W]ORD",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rne",
                function()
                    utils.search.within_cexpr(true)
                end,
                desc = "[e]xpr",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rnf",
                function()
                    utils.search.within_cfile(true)
                end,
                desc = "[f]ile",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rno",
                function()
                    utils.search.within(true)
                end,
                desc = "[o]pen",
                nowait = true,
                remap = false,
            },
            {
                "<leader>rnw",
                function()
                    utils.search.within_cword(true)
                end,
                desc = "[w]ord",
                nowait = true,
                remap = false,
            },
        },
    },
}

function M.config()
    require("which-key").add(options.mappings)
end

return M
