local icons = require("config.icons")

local utils = require("config.functions")

-- Os based finders
local file_finder = ""
local buffer_finder = ""
local help_finder = ""
file_finder = "<cmd>Telescope find_files<cr>"
buffer_finder = "<cmd>Telescope buffers sort_mru=true<cr>"
help_finder = "<cmd>Telescope help_tags<cr>"

local M = {}
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
            filetypes = { "TelescopePrompt" },
        },
    },

    opts = {
        mode = "n", -- NORMAL mode
        prefix = "<leader>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
    },
    vopts = {
        mode = "v", -- VISUAL mode
        prefix = "<leader>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
    },
    -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    vmappings = {
        ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
        l = {
            name = "LSP",
        },
        r = {
            name = "+Replace",
            -- Local (from current line)
            a = {
                name = "[a]sk",
                o = {
                    function()
                        utils.search.within(false)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        utils.search.within_cword(false)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        utils.search.within_cWORD(false)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        utils.search.within_cexpr(false)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        utils.search.within_cfile(false)
                    end,
                    "[f]ile",
                },
            },
            n = {
                name = "[n]o ask",
                o = {
                    function()
                        utils.search.within(true)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        utils.search.within_cword(true)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        utils.search.within_cWORD(true)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        utils.search.within_cexpr(true)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        utils.search.within_cfile(true)
                    end,
                    "[f]ile",
                },
            },
        },
    },
    mappings = {
        ["<space>"] = { ":nohlsearch<cr>", "Clear Highlight" },
        -- ["<space>"] = { '<cmd>let @/=""<CR>', "Clear Highlight" },
        ["w"] = { "<cmd>w<cr>", "Save" },
        ["q"] = {
            function()
                utils.smart_quit()
            end,
            "Quit",
        },
        ["/"] = {
            function()
                require("Comment.api").toggle.linewise.current()
            end,
            "Comment",
        },
        -- ["B"] = { "<cmd>JaqBuild<cr>", "JaqBuild" },
        -- ["Br"] = { "<cmd>JaqRun<cr>", "JaqRun" },
        -- ["R"] = { "<cmd>Jaq<cr>", "Jaq" },
        -- Plugins (Lazy)
        p = {
            name = "+Plugins",
            l = { "<cmd>Lazy<cr>", "Lazy" },
            i = { "<cmd>Lazy install<cr>", "Install" },
            r = { ":Lazy reload ", "Reload Plugin" },
            s = { "<cmd>Lazy sync<cr>", "Sync" },
            u = { "<cmd>Lazy update<cr>", "Update" },
        },
        -- Find (Telescope)
        f = {
            name = "+Find",
            b = { buffer_finder, "Buffers" },
            B = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
            e = { "<cmd>Telescope file_browser<cr>", "File Explorer" },
            f = { file_finder, "Find files" },
            g = { "<cmd>Telescope egrepify<cr>", "Find Text" },
            s = { "<cmd>Telescope grep_string<cr>", "Find String" },
            h = { help_finder, "Help" },
            -- H = { "<cmd>Telescope highlights<cr>", "Highlights" },
            H = { "<cmd>Telescope command_history<cr>", "Command History" },
            i = {
                function()
                    require("telescope").extensions.media_files.media_files()
                end,
                "Media",
            },
            l = { "<cmd>Telescope resume<cr>", "Last Search" },
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
            R = { "<cmd>Telescope registers<cr>", "Registers" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            C = { "<cmd>Telescope commands<cr>", "Commands" },
            P = { "<cmd>Telescope projects<CR>", "Projects" },
            y = { "<cmd>Telescope neoclip<CR>", "Neoclip" },
            t = { "<cmd>TodoTelescope<CR>", "Todo" },
            G = { "<cmd>Telescope advanced_git_search show_custom_functions<CR>", "Git" },
        },
        -- Replace
        r = {
            name = "+Replace",
            g = {
                name = "[g]lobal",
                a = {
                    name = "[a]sk",
                    o = {
                        function()
                            utils.search.open(true, false)
                        end,
                        "[o]pen",
                    },
                    w = {
                        function()
                            utils.search.cword(true, false)
                        end,
                        "[w]ord",
                    },
                    W = {
                        function()
                            utils.search.cWORD(true, false)
                        end,
                        "[W]ORD",
                    },
                    e = {
                        function()
                            utils.search.cexpr(true, false)
                        end,
                        "[e]xpr",
                    },
                    f = {
                        function()
                            utils.search.cfile(true, false)
                        end,
                        "[f]ile",
                    },
                },
                n = {
                    name = "[n]o ask",
                    o = {
                        function()
                            utils.search.open(true, true)
                        end,
                        "[o]pen",
                    },
                    w = {
                        function()
                            utils.search.cword(true, true)
                        end,
                        "[w]ord",
                    },
                    W = {
                        function()
                            utils.search.cWORD(true, true)
                        end,
                        "[W]ORD",
                    },
                    e = {
                        function()
                            utils.search.cexpr(true, true)
                        end,
                        "[e]xpr",
                    },
                    f = {
                        function()
                            utils.search.cfile(true, true)
                        end,
                        "[f]ile",
                    },
                },
            },
            -- Local (from current line)
            a = {
                name = "[a]sk",
                o = {
                    function()
                        utils.search.open(false, false)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        utils.search.cword(false, false)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        utils.search.cWORD(false, false)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        utils.search.cexpr(false, false)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        utils.search.cfile(false, false)
                    end,
                    "[f]ile",
                },
            },
            n = {
                name = "[n]o ask",
                o = {
                    function()
                        utils.search.open(false, true)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        utils.search.cword(false, true)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        utils.search.cWORD(false, true)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        utils.search.cexpr(false, true)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        utils.search.cfile(false, true)
                    end,
                    "[f]ile",
                },
            },
        },
        n = {
            name = "+Noice",
        },
        -- Trouble
        x = {
            name = "+Trouble",
        },
        -- Debug
        d = {
            name = "+Debug",
        },
        -- Git
        g = {
            name = "+Git",
            j = {
                function()
                    require("gitsigns").next_hunk()
                end,
                "Next Hunk",
            },
            k = {
                function()
                    require("gitsigns").prev_hunk()
                end,
                "Prev Hunk",
            },
            l = {
                function()
                    require("gitsigns").blame_line()
                end,
                "Blame Line",
            },
            L = { "<cmd>Git blame<cr>", "Blame" },
            p = {
                function()
                    require("gitsigns").preview_hunk()
                end,
                "Preview Hunk",
            },
            r = {
                function()
                    require("gitsigns").reset_hunk()
                end,
                "Reset Hunk",
            },
            R = {
                function()
                    require("gitsigns").reset_buffer()
                end,
                "Reset Buffer",
            },
            s = {
                function()
                    require("gitsigns").stage_hunk()
                end,
                "Stage Hunk",
            },
            u = {
                function()
                    require("gitsigns").undo_stage_hunk()
                end,
                "Undo Stage Hunk",
            },
            -- n = { ":!git checkout -b ", "Checkout New Branch" },
            o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
            b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
            c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
            f = { "<cmd>Telescope git_bcommits<cr>", "Checkout buffer commit" },
            d = {
                name = "+Diff",
                h = { "<cmd>DiffviewFileHistory %<cr>", "Diff View File History (Current File)" },
                o = { "<cmd>DiffviewOpen<cr>", "Diff View Open" },
                c = { "<cmd>DiffviewClose<cr>", "Diff View Close" },
            },
            n = { "<cmd>Neogit<cr>", "Neogit" },
        },
        -- Lsp
        l = {
            name = "+LSP",
        },
        ["gp"] = {
            name = "+Glance",
            d = { "<CMD>Glance definitions<CR>", "Glance Definitions" },
            r = { "<CMD>Glance references<CR>", "Glance References" },
            t = { "<CMD>Glance type_definitions<CR>", "Glance Type" },
            i = { "<CMD>Glance implementations<CR>", "Glance Implementations" },
        },
        -- Buffers
        b = {
            name = "+Buffers",
            j = { "<cmd>BufferLinePick<cr>", "Jump" },
            f = { buffer_finder, "Find" },
            p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
            n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
            d = {
                "<cmd>BufferLinePickClose<cr>",
                "Pick which buffer to close",
            },
            h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
            l = {
                "<cmd>BufferLineCloseRight<cr>",
                "Close all to the right",
            },
            ["sd"] = {
                "<cmd>BufferLineSortByDirectory<cr>",
                "Sort by directory",
            },
            ["sl"] = {
                "<cmd>BufferLineSortByExtension<cr>",
                "Sort by language",
            },
            D = {
                function()
                    utils.delete_empty_buffers()
                end,
                "Delete all empty buffers",
            },
        },
        -- Misc Window
        o = {
            "+Window",
            n = { "<cmd>only<cr>", "Focus This Window" },
            f = {
                function()
                    utils.focus_first_float()
                end,
                "Focus Floating Window",
            },
        },
        -- Splits
        s = {
            name = "+Split",
            h = { "<cmd>leftabove vs<cr>", "Left" },
            l = { "<cmd>rightbelow vs<cr>", "Right" },
            k = { "<cmd>leftabove split<cr>", "Up" },
            j = { "<cmd>rightbelow split<cr>", "Down" },
        },
        -- Tabs
        -- T = {
        --     name = "+Tab",
        --     t = {
        --         "<cmd>lua require('telescope').extensions['telescope-tabs'].list_tabs(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal', prompt_title='Tabs'})<cr>",
        --         "Find Tab",
        --     },
        --     n = { "<cmd>tabnew %<cr>", "New Tab" },
        --     c = { "<cmd>tabclose<cr>", "Close Tab" },
        --     o = { "<cmd>tabonly<cr>", "Only Tab" },
        -- },
        -- Testing
        T = { name = "+Test" },
        -- Terminal
        t = {
            name = "+Terminal",
        },
        -- Folds
        z = {
            name = "+Folds",
            o = {
                function()
                    require("ufo").openAllFolds()
                end,
                "Open All Folds",
            },
            c = {
                function()
                    require("ufo").closeAllFolds()
                end,
                "Close All Folds",
            },
        },
        -- Options
        O = {
            name = "+Options",
            -- c = { "<cmd>lua lvim.builtin.cmp.active = false<cr>", "Completion off" },
            -- C = { "<cmd>lua lvim.builtin.cmp.active = true<cr>", "Completion on" },
            w = {
                function()
                    utils.toggle_option("wrap")
                end,
                "Wrap",
            },
            -- r = { '<cmd>lua require("config.functions").toggle_option("relativenumber")<cr>', "Relative" },
            -- l = { '<cmd>lua require("config.functions").toggle_option("cursorline")<cr>', "Cursorline" },
            s = {
                function()
                    utils.toggle_option("spell")
                end,
                "Spell",
            },
            -- t = { '<cmd>lua require("config.functions").toggle_tabline()<cr>', "Tabline" },
        },
    },
}

function M.config()
    local which_key = require("which-key")

    local opts = options.opts
    local vopts = options.vopts

    local mappings = options.mappings
    local vmappings = options.vmappings

    which_key.register(mappings, opts)
    which_key.register(vmappings, vopts)
end

return M
