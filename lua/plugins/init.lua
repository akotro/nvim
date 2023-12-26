return {
    -- NOTE: Colorschemes
    {
        "rebelot/kanagawa.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            local status, kanagawa = pcall(require, "kanagawa")
            if not status then
                vim.notify("Kanagawa not found", vim.log.levels.ERROR)
            else
                kanagawa.setup({
                    compile = true,
                    colors = {
                        theme = { all = { ui = { bg_gutter = "none" } } },
                    },
                })
                vim.cmd([[colorscheme kanagawa]])
            end
        end,
    },
    -- NOTE: Util
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    -- NOTE: UI
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            select = {
                backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                get_config = function(opts)
                    if opts.kind == "Jaq" then
                        return {
                            backend = "builtin",
                        }
                    end
                end,
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },
    {
        "folke/noice.nvim",
        enabled = true,
        event = "User",
        dependencies = "MunifTanjim/nui.nvim",
        config = function()
            require("plugins.noice").setup()
        end,
        keys = require("plugins.noice").keys,
    },
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
            -- { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            -- { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
        },
        opts = {
            options = {
                close_command = function(n)
                    require("mini.bufremove").delete(n, false)
                end,
                right_mouse_command = function(n)
                    require("mini.bufremove").delete(n, false)
                end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                diagnostics_indicator = function(_, _, diag)
                    local icons = require("config.icons").diagnostics
                    local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                        .. (diag.warning and icons.Warn .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
        end,
    },
    -- NOTE: Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            vim.o.laststatus = vim.g.lualine_laststatus

            return require("plugins.lualine")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        opts = {
            indent = {
                char = require("config.icons").ui.LineLeft,
                tab_char = require("config.icons").ui.LineLeft,
            },
            scope = {
                enabled = false,
                char = require("config.icons").ui.LineLeft,
            },
            exclude = {
                buftypes = { "terminal", "nofile" },
                filetypes = {
                    "help",
                    "startify",
                    "dashboard",
                    "lazy",
                    "neogitstatus",
                    "NvimTree",
                    "Trouble",
                    "text",
                    "neorg",
                    "oil",
                },
            },
        },
        main = "ibl",
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = "BufRead",
        opts = {
            symbol = require("config.icons").ui.LineLeft,
            options = { try_as_border = true },
            draw = {
                delay = 50,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },
    {
        "echasnovski/mini.ai",
        -- keys = {
        --   { "a", mode = { "x", "o" } },
        --   { "i", mode = { "x", "o" } },
        -- },
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- register all text objects with which-key
            require("config.functions").on_load("which-key.nvim", function()
                ---@type table<string, string|table>
                local i = {
                    [" "] = "Whitespace",
                    ['"'] = 'Balanced "',
                    ["'"] = "Balanced '",
                    ["`"] = "Balanced `",
                    ["("] = "Balanced (",
                    [")"] = "Balanced ) including white-space",
                    [">"] = "Balanced > including white-space",
                    ["<lt>"] = "Balanced <",
                    ["]"] = "Balanced ] including white-space",
                    ["["] = "Balanced [",
                    ["}"] = "Balanced } including white-space",
                    ["{"] = "Balanced {",
                    ["?"] = "User Prompt",
                    _ = "Underscore",
                    a = "Argument",
                    b = "Balanced ), ], }",
                    c = "Class",
                    f = "Function",
                    o = "Block, conditional, loop",
                    q = "Quote `, \", '",
                    t = "Tag",
                }
                local a = vim.deepcopy(i)
                for k, v in pairs(a) do
                    a[k] = v:gsub(" including.*", "")
                end

                local ic = vim.deepcopy(i)
                local ac = vim.deepcopy(a)
                for key, name in pairs({ n = "Next", l = "Last" }) do
                    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
                    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
                end
                require("which-key").register({
                    mode = { "o", "x" },
                    i = i,
                    a = a,
                })
            end)
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("plugins.autopairs").setup()
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    },
    {
        "RRethy/vim-illuminate",
        event = "BufRead",
        opts = {
            providers = {
                "treesitter",
                "lsp",
                "regex",
            },
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },
    {
        "kylechui/nvim-surround",
        event = "BufRead",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "monaqa/dial.nvim",
        event = "BufRead",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.integer.alias.binary,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%m/%d"],
                    augend.date.alias["%H:%M"],
                    augend.constant.alias.ja_weekday_full,
                    augend.constant.alias.bool,
                    augend.constant.alias.alpha,
                    augend.constant.alias.Alpha,
                    augend.semver.alias.semver,
                },
            })
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), opts)
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), opts)
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), opts)
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), opts)
            vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), opts)
            vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), opts)
        end,
    },
    {
        "windwp/nvim-spectre",
        event = "BufRead",
        config = function()
            vim.cmd([[
                nnoremap <leader>S <cmd>lua require('spectre').open()<CR>

                "search current word
                nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
                vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
                "  search in current file
                nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
            ]])
        end,
    },
    {
        "NMAC427/guess-indent.nvim",
        event = "BufReadPre",
        config = function()
            require("guess-indent").setup({})
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                filetypes = { "html", "css", "javascript", "vim", "lua", "sh", "zsh" },
                user_default_options = {
                    css = true,
                    mode = "virtualtext",
                    virtualtext = "󰹞󰹞󰹞",
                },
            })
        end,
    },
    {
        "echasnovski/mini.bufremove",
        -- keys = {
        --     {
        --         "<leader>bd",
        --         function()
        --             local bd = require("mini.bufremove").delete
        --             if vim.bo.modified then
        --                 local choice =
        --                     vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
        --                 if choice == 1 then -- Yes
        --                     vim.cmd.write()
        --                     bd(0)
        --                 elseif choice == 2 then -- No
        --                     bd(0, true)
        --                 end
        --             else
        --                 bd(0)
        --             end
        --         end,
        --         desc = "Delete Buffer",
        --     },
        --     {
        --         "<leader>bD",
        --         function()
        --             require("mini.bufremove").delete(0, true)
        --         end,
        --         desc = "Delete Buffer (Force)",
        --     },
        -- },
    },
    {
        "akotro/jaq-nvim",
        ft = { "c", "cpp", "cs", "markdown", "python", "sh", "rust" },
        config = require("plugins.jaq").config,
    },
    {
        "kevinhwang91/nvim-bqf",
        event = "BufRead",
        config = function()
            require("bqf").setup({
                auto_enable = true,
                auto_resize_height = true,
            })
        end,
    },
    {
        url = "https://gitlab.com/yorickpeterse/nvim-pqf",
        name = "nvim-pqf",
        event = "BufRead",
        config = function()
            require("pqf").setup()
        end,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufRead",
        config = require("plugins.ufo").config,
    },
    {
        "kevinhwang91/nvim-hlslens",
        lazy = true,
        -- event = "BufRead",
        keys = require("plugins.hlslens").keys,
        config = require("plugins.hlslens").config,
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").open_float()
                end,
                desc = "Explorer",
            },
        },
        config = function()
            require("oil").setup({
                columns = {
                    "icon",
                    "size",
                    -- "permissions",
                    -- "mtime",
                },
                default_file_explorer = true,
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    -- ["<C-s>"] = "actions.select_vsplit",
                    -- ["<C-h>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["g."] = "actions.toggle_hidden",
                },
                use_default_keymaps = false,
                view_options = {
                    show_hidden = true,
                },
                float = {
                    padding = 4,
                },
            })
        end,
    },
    {
        "samjwill/nvim-unception",
        init = function()
            -- vim.g.unception_open_buffer_in_new_tab = true
        end,
        event = "VeryLazy",
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        lazy = true,
        keys = {
            {
                "<c-\\>",
                [[<cmd>exe v:count1 . "ToggleTerm"<cr>]],
                desc = "Toggle Terminal",
                mode = "",
            },
            {
                "<leader>to",
                "<cmd>ToggleTerm<cr>",
                desc = "Toggle Terminal",
            },
            {
                "<leader>tf",
                [[<cmd>exe v:count1 . "ToggleTerm direction='float'"<cr>]],
                desc = "Toggle Floating Terminal",
            },
            {
                "<leader>th",
                [[<cmd>exe v:count1 . "ToggleTerm direction='horizontal'"<cr>]],
                desc = "Toggle Horizontal Terminal",
            },
            {
                "<leader>tv",
                [[<cmd>exe v:count1 . "ToggleTerm direction='vertical'"<cr>]],
                desc = "Toggle Vertical Terminal",
            },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            start_in_insert = false,
            -- open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = {
                border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
            },
        },
    },
    -- NOTE: Git
    { "tpope/vim-fugitive", event = "BufRead" },
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewFileHistory",
            "DiffviewFocusFiles",
            "DiffviewLog",
            "DiffviewRefresh",
            "DiffviewToggleFiles",
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        cmd = "Gitsigns",
        opts = function()
            local icons = require("config.icons")
            return {
                signs = {
                    add = {
                        hl = "GitSignsAdd",
                        text = icons.ui.BoldLineLeft,
                        numhl = "GitSignsAddNr",
                        linehl = "GitSignsAddLn",
                    },
                    change = {
                        hl = "GitSignsChange",
                        text = icons.ui.BoldLineLeft,
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                    delete = {
                        hl = "GitSignsDelete",
                        text = icons.ui.Triangle,
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    topdelete = {
                        hl = "GitSignsDelete",
                        text = icons.ui.Triangle,
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    changedelete = {
                        hl = "GitSignsChange",
                        text = icons.ui.BoldLineLeft,
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
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
                yadm = { enable = false },
            }
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            padding = true,
            sticky = true,
            ignore = "^$",
            mappings = {
                basic = true,
                extra = true,
            },
            toggler = {
                line = "gcc",
                block = "gbc",
            },
            opleader = {
                line = "gc",
                block = "gb",
            },
            extra = {
                above = "gcO",
                below = "gco",
                eol = "gcA",
            },
            pre_hook = function(...)
                local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
                if loaded and ts_comment then
                    return ts_comment.create_pre_hook()(...)
                end
            end,
            post_hook = nil,
        },
        keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
        event = "User FileOpened",
    },
    -- NOTE: Keymaps
    {
        "folke/which-key.nvim",
        config = function()
            require("plugins.whichkey").setup()
        end,
        cmd = "WhichKey",
        event = "VeryLazy",
    },

    -- NOTE: Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- event = { "LazyFile", "VeryLazy" },
        init = require("plugins.treesitter").init,
        dependencies = require("plugins.treesitter").dependencies,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = require("plugins.treesitter").keys,
        opts = require("plugins.treesitter").opts,
        config = require("plugins.treesitter").config,
    },
    -- Show context of the current function
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufRead",
        enabled = true,
        opts = { enable = false, mode = "cursor", max_lines = 3 },
        keys = {
            {
                "<leader>ut",
                function()
                    local tsc = require("treesitter-context")
                    tsc.toggle()
                end,
                desc = "Toggle Treesitter Context",
            },
        },
    },
    -- comments
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },
    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        event = "BufRead",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "xml",
            "markdown",
        },
        opts = {},
    },
    {
        "m-demare/hlargs.nvim",
        event = "BufRead",
        config = function()
            require("hlargs").setup({
                color = "#f38ba8",
                -- color = "#A3D4D5",
                -- color = "#8ec07c"
            })
        end,
    },
    -- NOTE: Completion
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        build = (not jit.os:find("Windows"))
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = require("plugins.completion").luasnip.opts,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = require("plugins.completion").cmp.dependencies,
        opts = require("plugins.completion").cmp.opts,
        config = require("plugins.completion").cmp.config,
    },
    -- NOTE: Linting
    {
        "mfussenegger/nvim-lint",
        event = "BufRead",
        opts = require("plugins.linting").opts,
        config = require("plugins.linting").config,
    },
    -- NOTE: Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = require("plugins.formatting").keys,
        opts = require("plugins.formatting").opts,
        init = require("plugins.formatting").init,
    },
    -- NOTE: LSP
    {
        "neovim/nvim-lspconfig",
        event = "BufRead",
        dependencies = {
            -- { "folke/neoconf.nvim", cmd = "Neoconf", config = false },
            { "folke/neodev.nvim", opts = {} },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} },

            -- NOTE: LSP Language Extensions
            { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true, ft = "cs" },
            {
                "simrat39/rust-tools.nvim",
                lazy = true,
                ft = { "rust", "toml" },
                opts = function()
                    local ok, mason_registry = pcall(require, "mason-registry")
                    local adapter ---@type any
                    if ok then
                        -- rust tools configuration for debugging support
                        local codelldb = mason_registry.get_package("codelldb")
                        local extension_path = codelldb:get_install_path() .. "/extension/"
                        local codelldb_path = extension_path .. "adapter/codelldb"
                        local liblldb_path = ""
                        if vim.loop.os_uname().sysname:find("Windows") then
                            liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
                        elseif vim.fn.has("mac") == 1 then
                            liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
                        else
                            liblldb_path = extension_path .. "lldb/lib/liblldb.so"
                        end
                        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
                    end
                    return {
                        dap = {
                            adapter = adapter,
                        },
                        tools = {
                            on_initialized = function()
                                vim.cmd([[
									augroup RustLSP
									  " autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
									  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
									  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
									augroup END
							   ]])
                            end,
                        },
                    }
                end,
                config = function() end,
            },
            {
                "saecki/crates.nvim",
                lazy = true,
                ft = { "rust", "toml" },
                opts = {
                    src = {
                        cmp = { enabled = true },
                    },
                },
            },
            {
                "pmizio/typescript-tools.nvim",
                lazy = true,
                -- ft = { "ts", "tsx", "js", "jsx" },
                dependencies = { "nvim-lua/plenary.nvim" },
                opts = {},
            },
            {
                "p00f/clangd_extensions.nvim",
                lazy = true,
                config = function() end,
                opts = {
                    inlay_hints = {
                        inline = false,
                    },
                    ast = {
                        --These require codicons (https://github.com/microsoft/vscode-codicons)
                        role_icons = {
                            type = "",
                            declaration = "",
                            expression = "",
                            specifier = "",
                            statement = "",
                            ["template argument"] = "",
                        },
                        kind_icons = {
                            Compound = "",
                            Recovery = "",
                            TranslationUnit = "",
                            PackExpansion = "",
                            TemplateTypeParm = "",
                            TemplateTemplateParm = "",
                            TemplateParamObject = "",
                        },
                    },
                },
            },
        },
        opts = require("plugins.lsp").opts,
        config = require("plugins.lsp").config,
    },
    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                "stylua",
                "shfmt",
                "beautysh",
                -- "flake8",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    -- NOTE: LSP Utils
    -- {
    --	"ray-x/lsp_signature.nvim",
    --	event = "BufRead",
    --	config = function()
    --		require("lsp_signature").setup({
    --			hint_enable = false,
    --		})
    --	end,
    -- },
    {
        "Bekaboo/dropbar.nvim",
        event = "BufRead",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },
    {
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
        config = function()
            local icons = require("config.icons")
            require("nvim-lightbulb").setup({
                sign = {
                    enabled = false,
                    priority = 10,
                },
                virtual_text = {
                    enabled = true,
                    -- text = " ",
                    text = icons.ui.Lightbulb,
                    hl_mode = "combine",
                },
                status_text = {
                    enabled = false,
                    -- text = "",
                    icons.ui.Lightbulb,
                    text_unavailable = "",
                },
                autocmd = {
                    enabled = true,
                    pattern = { "*" },
                    events = { "CursorHold", "CursorHoldI" },
                },
            })
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        event = "BufRead",
        config = function()
            require("inc_rename").setup()
            -- require("inc_rename").setup({
            --	input_buffer_type = "dressing",
            -- })
        end,
    },
    {
        "dnlhc/glance.nvim",
        cmd = "Glance",
        config = function()
            require("glance").setup()
        end,
    },
    {
        "Kasama/nvim-custom-diagnostic-highlight",
        event = "BufRead",
        config = function()
            require("nvim-custom-diagnostic-highlight").setup({})
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        build = ":Copilot auth",
        keys = {
            {
                "<leader>cpe",
                "<cmd>Copilot enable<cr>",
                desc = "Copilot Enable",
            },
            {
                "<leader>cpd",
                "<cmd>Copilot disable<cr>",
                desc = "Copilot Disable",
            },
        },
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
            vim.cmd("silent! Copilot disable")
        end,
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        name = "lsp_lines.nvim",
        event = "BufRead",
        config = function()
            require("lsp_lines").setup()
        end,
    },
    -- NOTE: Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = require("plugins.debug").dependencies,
        keys = require("plugins.debug").keys,
        config = require("plugins.debug").config,
    },
    -- NOTE: Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        opts = require("plugins.telescope").opts,
        dependencies = require("plugins.telescope").dependencies,
        lazy = true,
        cmd = "Telescope",
    },
    -- NOTE: Trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },

    -- NOTE: Writing
    -- jbyuki/nabla.nvim
    -- Latex Notes
    --  - https://castel.dev/post/lecture-notes-1/
    --  - lervag/vimtex
    {
        "folke/zen-mode.nvim",
        ft = { "txt", "markdown", "norg" },
        cmd = "ZenMode",
        config = function()
            require("zen-mode").setup({})
        end,
    },
    -- NOTE: Markdown
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = { "txt", "markdown", "norg" },
        cmd = "TableModeToggle",
        config = function()
            vim.g.table_mode_corner = "|"
        end,
    },
    -- NOTE: Neorg
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        ft = { "norg" },
        cmd = "Neorg",
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        icon_preset = "diamond",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                        default_workspace = "notes",
                    },
                },
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.presenter"] = {
                    config = {
                        zen_mode = "zen-mode",
                    },
                },
                ["core.summary"] = {},
                ["core.export"] = {},
                ["core.export.markdown"] = {
                    config = {
                        extensions = "all",
                    },
                },
            },
        },
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    -- NOTE: Web
    { "mattn/emmet-vim", ft = { "html", "css", "js" } },
    -- { "manzeloth/live-server", cmd = "LiveServer" },

    -- NOTE: Database
    {
        "tpope/vim-dadbod",
        lazy = true,
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "kristijanhusak/vim-dadbod-completion",
        },
        config = function()
            require("plugins.dadbod").setup()
        end,
        cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    },
}
