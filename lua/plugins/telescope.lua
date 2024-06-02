local M = {}

M.keys = {
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Buffers" },
    { "<leader>fB", "<cmd>Telescope git_branches<cr>", desc = "Checkout Branch" },
    { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
    { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Explorer" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope egrepify<cr>", desc = "Find Text" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find String" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    -- { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
    { "<leader>fH", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    {
        "<leader>fi",
        function()
            require("telescope").extensions.media_files.media_files()
        end,
        desc = "Media",
    },
    { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
    { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
    { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>fP", "<cmd>Telescope projects<CR>", desc = "Projects" },
    { "<leader>fy", "<cmd>Telescope neoclip<CR>", desc = "Neoclip" },
    { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo" },
    { "<leader>fG", "<cmd>Telescope advanced_git_search show_custom_functions<CR>", desc = "Git" },
}

function M.opts()
    local functions = require("config.functions")
    local icons = require("config.icons")
    local actions = require("telescope.actions")

    local layout_strategy = "horizontal"
    if functions.window.is_portrait_mode() then
        layout_strategy = "vertical"
    end

    local egrep_actions = require("telescope._extensions.egrepify.actions")

    local open_with_trouble = require("trouble.sources.telescope").open
    -- Use this to add more results without clearing the trouble list
    local add_to_trouble = require("trouble.sources.telescope").add

    return {
        defaults = {
            prompt_prefix = icons.ui.Telescope .. " ",
            selection_caret = icons.ui.Forward .. " ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = layout_strategy,
            layout_config = {},
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
            mappings = {
                i = {
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-c>"] = actions.close,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = function(...)
                        actions.smart_send_to_qflist(...)
                        actions.open_qflist(...)
                    end,
                    ["<CR>"] = actions.select_default,
                    ["<c-t>"] = open_with_trouble,
                },
                n = {
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-q>"] = function(...)
                        actions.smart_send_to_qflist(...)
                        actions.open_qflist(...)
                    end,
                    ["<c-t>"] = open_with_trouble,
                },
            },
            file_ignore_patterns = {
                ".git/",
                ".git/*",
                "target/",
                "docs/",
                "vendor/*",
                "%.lock",
                "__pycache__/*",
                "%.sqlite3",
                "%.ipynb",
                "node_modules/*",
                -- "%.jpg",
                -- "%.jpeg",
                -- "%.png",
                "%.svg",
                "%.otf",
                "%.ttf",
                "%.webp",
                ".dart_tool/",
                ".github/",
                ".gradle/",
                ".idea/",
                ".settings/",
                ".vscode/",
                "__pycache__/",
                "build/",
                "env/",
                "gradle/",
                "node_modules/",
                "%.pdb",
                "%.dll",
                "%.class",
                "%.exe",
                "%.cache",
                "%.ico",
                "%.pdf",
                "%.dylib",
                "%.jar",
                "%.docx",
                "%.met",
                "smalljre_*/*",
                ".vale/",
                "%.burp",
                "%.mp4",
                "%.mkv",
                "%.rar",
                "%.zip",
                "%.7z",
                "%.tar",
                "%.bz2",
                "%.epub",
                "%.flac",
                "%.tar.gz",
                -- vs files
                ".vs/*",
                "packages/*",
                "obj/*",
                "build/*",
            },
            path_display = { "smart" },
            winblend = 0,
            border = {},
            borderchars = nil,
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            live_grep = {
                --@usage don't include the filename in the search results
                only_sort_text = true,
            },
            grep_string = {
                only_sort_text = true,
            },
            buffers = {
                initial_mode = "insert",
                mappings = {
                    i = {
                        ["<C-d>"] = actions.delete_buffer,
                    },
                    n = {
                        ["dd"] = actions.delete_buffer,
                    },
                },
            },
            planets = {
                show_pluto = true,
                show_moon = true,
            },
            git_files = {
                hidden = true,
                show_untracked = true,
            },
            colorscheme = {
                enable_preview = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
            egrepify = {
                -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
                -- if str1 and str2 are consecutively in line with anything in between (wildcard)
                AND = true, -- default
                permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
                lnum = true, -- default, not required
                lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
                col = false, -- default, not required
                col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
                title = true, -- default, not required, show filename as title rather than inline
                filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
                -- suffix = long line, see screenshot
                -- EXAMPLE ON HOW TO ADD PREFIX!
                prefixes = {
                    -- ADDED ! to invert matches
                    -- example prompt: ! sorter
                    -- matches all lines that do not comprise sorter
                    -- rg --invert-match -- sorter
                    ["!"] = {
                        flag = "invert-match",
                    },
                    -- HOW TO OPT OUT OF PREFIX
                    -- ^ is not a default prefix and safe example
                    ["^"] = false,
                },
                -- default mappings
                mappings = {
                    i = {
                        -- toggle prefixes, prefixes is default
                        ["<C-z>"] = egrep_actions.toggle_prefixes,
                        -- toggle AND, AND is default, AND matches tokens and any chars in between
                        ["<C-a>"] = egrep_actions.toggle_and,
                        -- toggle permutations, permutations of tokens is opt-in
                        ["<C-r>"] = egrep_actions.toggle_permutations,
                    },
                },
            },
        },
    }
end

M.dependencies = {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
    {
        "AckslD/nvim-neoclip.lua",
        -- event = "BufRead",
        lazy = true,
        config = function()
            require("neoclip").setup({
                default_register = "+",
            })
            require("config.functions").on_load("telescope.nvim", function()
                pcall(require("telescope").load_extension, "neoclip")
            end)
        end,
    },
    {
        "debugloop/telescope-undo.nvim",
        -- event = "BufRead",
        lazy = true,
        config = function()
            require("config.functions").on_load("telescope.nvim", function()
                pcall(require("telescope").load_extension, "undo")
            end)
        end,
    },
    {
        "aaronhallaert/advanced-git-search.nvim",
        -- event = "BufRead",
        lazy = true,
        config = function()
            require("config.functions").on_load("telescope.nvim", function()
                pcall(require("telescope").load_extension, "advanced_git_search")
            end)
        end,
    },
    {
        "fdschmidt93/telescope-egrepify.nvim",
        lazy = true,
        config = function()
            require("config.functions").on_load("telescope.nvim", function()
                pcall(require("telescope").load_extension, "egrepify")
            end)
        end,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        -- event = "BufRead",
        lazy = true,
        opts = {
            keywords = {
                TODO = { color = "error" },
            },
        },
        config = true,
        keys = {
            -- {
            --     "]t",
            --     function()
            --         require("todo-comments").jump_next()
            --     end,
            --     desc = "Next todo comment",
            -- },
            -- {
            --     "[t",
            --     function()
            --         require("todo-comments").jump_prev()
            --     end,
            --     desc = "Previous todo comment",
            -- },
        },
    },
}

return M
