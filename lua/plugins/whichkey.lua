local icons = require("config.icons")

local utils = require("config.functions")

-- Os based finders
local file_finder = ""
local buffer_finder = ""
local help_finder = ""
-- if utils.is_win() then
file_finder = "<cmd>Telescope find_files<cr>"
-- buffer_finder = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>"
buffer_finder = "<cmd>Telescope buffers sort_mru=true<cr>"
help_finder = "<cmd>Telescope help_tags<cr>"
-- else
-- 	file_finder = "<cmd>CommandTRipgrep<cr>"
-- 	buffer_finder = "<cmd>CommandTBuffer<cr>"
-- 	help_finder = "<cmd>CommandTHelp<cr>"
-- end

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
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        },
        r = {
            name = "+Replace",
            -- Local (from current line)
            a = {
                name = "[a]sk",
                o = {
                    function()
                        require("config.functions").search.within(false)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        require("config.functions").search.within_cword(false)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        require("config.functions").search.within_cWORD(false)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        require("config.functions").search.within_cexpr(false)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        require("config.functions").search.within_cfile(false)
                    end,
                    "[f]ile",
                },
            },
            n = {
                name = "[n]o ask",
                o = {
                    function()
                        require("config.functions").search.within(true)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        require("config.functions").search.within_cword(true)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        require("config.functions").search.within_cWORD(true)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        require("config.functions").search.within_cexpr(true)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        require("config.functions").search.within_cfile(true)
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
        ["q"] = { '<cmd>lua require("config.functions").smart_quit()<CR>', "Quit" },
        ["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
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
            i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
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
                            require("config.functions").search.open(true, false)
                        end,
                        "[o]pen",
                    },
                    w = {
                        function()
                            require("config.functions").search.cword(true, false)
                        end,
                        "[w]ord",
                    },
                    W = {
                        function()
                            require("config.functions").search.cWORD(true, false)
                        end,
                        "[W]ORD",
                    },
                    e = {
                        function()
                            require("config.functions").search.cexpr(true, false)
                        end,
                        "[e]xpr",
                    },
                    f = {
                        function()
                            require("config.functions").search.cfile(true, false)
                        end,
                        "[f]ile",
                    },
                },
                n = {
                    name = "[n]o ask",
                    o = {
                        function()
                            require("config.functions").search.open(true, true)
                        end,
                        "[o]pen",
                    },
                    w = {
                        function()
                            require("config.functions").search.cword(true, true)
                        end,
                        "[w]ord",
                    },
                    W = {
                        function()
                            require("config.functions").search.cWORD(true, true)
                        end,
                        "[W]ORD",
                    },
                    e = {
                        function()
                            require("config.functions").search.cexpr(true, true)
                        end,
                        "[e]xpr",
                    },
                    f = {
                        function()
                            require("config.functions").search.cfile(true, true)
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
                        require("config.functions").search.open(false, false)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        require("config.functions").search.cword(false, false)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        require("config.functions").search.cWORD(false, false)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        require("config.functions").search.cexpr(false, false)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        require("config.functions").search.cfile(false, false)
                    end,
                    "[f]ile",
                },
            },
            n = {
                name = "[n]o ask",
                o = {
                    function()
                        require("config.functions").search.open(false, true)
                    end,
                    "[o]pen",
                },
                w = {
                    function()
                        require("config.functions").search.cword(false, true)
                    end,
                    "[w]ord",
                },
                W = {
                    function()
                        require("config.functions").search.cWORD(false, true)
                    end,
                    "[W]ORD",
                },
                e = {
                    function()
                        require("config.functions").search.cexpr(false, true)
                    end,
                    "[e]xpr",
                },
                f = {
                    function()
                        require("config.functions").search.cfile(false, true)
                    end,
                    "[f]ile",
                },
            },
        },
        -- Trouble
        n = {
            name = "+Noice",
        },
        x = {
            name = "+Trouble",
            x = { "<cmd>TroubleToggle<cr>", "Toggle" },
            w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
            d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
            r = { "<cmd>Trouble lsp_references<cr>", "References" },
            f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
            q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
            l = { "<cmd>Trouble loclist<cr>", "LocationList" },
            t = { "<cmd>TodoTrouble<cr>", "Todo" },
            j = {
                function()
                    require("trouble").next({ skip_groups = true, jump = true })
                end,
                "Next Item",
            },
            k = {
                function()
                    require("trouble").previous({ skip_groups = true, jump = true })
                end,
                "Previous Item",
            },
        },
        -- Debug
        d = {
            name = "+Debug",
        },
        -- Git
        g = {
            name = "+Git",
            j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
            k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
            l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame Line" },
            L = { "<cmd>Git blame<cr>", "Blame" },
            p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
            R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
            u = {
                "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
                "Undo Stage Hunk",
            },
            -- n = { ":!git checkout -b ", "Checkout New Branch" },
            o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
            b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
            c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
            f = { "<cmd>Telescope git_bcommits<cr>", "Checkout buffer commit" },
            d = { "<cmd>DiffviewOpen<cr>", "Diff" },
            n = { "<cmd>Neogit<cr>", "Neogit" },
        },
        -- Lsp
        l = {
            name = "+LSP",
            -- D = {
            -- 	function()
            -- 		require("config.functions").open_diagnostic()
            -- 	end,
            -- 	"Open Diagnostic Float",
            -- },
            c = {
                ":NvimCmpToggle<CR>",
                "Toggle Autocomplete",
            },
            w = {
                "<cmd>Telescope lsp_workspace_diagnostics<cr>",
                "Workspace Diagnostics",
            },
            h = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", "Toggle Hints" },
            H = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
            I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
            j = {
                "<cmd>lua vim.diagnostic.goto_next({buffer=0, float=false})<CR>",
                "Next Diagnostic",
            },
            k = {
                "<cmd>lua vim.diagnostic.goto_prev({buffer=0, float=false})<cr>",
                "Prev Diagnostic",
            },
            v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Virtual Text" },
            l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
            o = { "<cmd>SymbolsOutline<cr>", "Outline" },
            q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
            -- r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
            -- r = {
            -- 	function()
            -- 		return ":IncRename " .. vim.fn.expand("<cword>")
            -- 	end,
            -- 	"Rename",
            -- 	expr = true,
            -- },
            R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
            S = {
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                "Workspace Symbols",
            },
            t = { '<cmd>lua require("config.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
            L = {
                function()
                    require("lsp_lines").toggle()
                end,
                "LSP Lines",
            },
            u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
        },
        -- TODO: Glance
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
            D = {
                "<cmd>BufferLineSortByDirectory<cr>",
                "Sort by directory",
            },
            L = {
                "<cmd>BufferLineSortByExtension<cr>",
                "Sort by language",
            },
        },
        -- Misc Window
        o = {
            "+Window",
            n = { "<cmd>only<cr>", "Focus This Window" },
            f = { [[<cmd>lua require("config.functions").focus_first_float()<cr>]], "Focus Floating Window" },
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
            o = { "<cmd>lua require('ufo').openAllFolds<cr>", "Open All Folds" },
            c = { "<cmd>lua require('ufo').closeAllFolds<cr>", "Close All Folds" },
        },
        -- Options
        O = {
            name = "+Options",
            -- c = { "<cmd>lua lvim.builtin.cmp.active = false<cr>", "Completion off" },
            -- C = { "<cmd>lua lvim.builtin.cmp.active = true<cr>", "Completion on" },
            w = { '<cmd>lua require("config.functions").toggle_option("wrap")<cr>', "Wrap" },
            -- r = { '<cmd>lua require("config.functions").toggle_option("relativenumber")<cr>', "Relative" },
            -- l = { '<cmd>lua require("config.functions").toggle_option("cursorline")<cr>', "Cursorline" },
            s = { '<cmd>lua require("config.functions").toggle_option("spell")<cr>', "Spell" },
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
