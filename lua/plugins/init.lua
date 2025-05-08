return {
    -- NOTE: Colorschemes
    {
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = true,
        config = require("plugins.kanagawa").config,
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = true,
        opts = {
            style = "night",
        },
    },
    {
        "wnkz/monoglow.nvim",
        enabled = false,
        lazy = true,
        opts = {},
    },
    {
        "EdenEast/nightfox.nvim",
        enabled = true,
        lazy = true,
        priority = 1000,
        opts = {
            transparent = false,
        },
        init = function()
            vim.api.nvim_command("colorscheme carbonfox")
        end,
    },
    -- NOTE: Util
    { "nvim-lua/plenary.nvim", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        dependencies = require("plugins.snacks").dependencies,
        opts = require("plugins.snacks").opts,
        keys = require("plugins.snacks").keys,
        init = require("plugins.snacks").init,
    },
    -- NOTE: UI
    {
        "echasnovski/mini.icons",
        version = false,
        lazy = false,
        config = function()
            local mini_icons = require("mini.icons")
            mini_icons.setup()
            mini_icons.mock_nvim_web_devicons()
        end,
    },
    {
        "folke/noice.nvim",
        enabled = false,
        event = "User",
        dependencies = "MunifTanjim/nui.nvim",
        keys = require("plugins.noice").keys,
        config = require("plugins.noice").config,
    },
    {
        "akinsho/bufferline.nvim",
        enabled = false,
        event = "VeryLazy",
        keys = require("plugins.bufferline").keys,
        dependencies = require("plugins.bufferline").dependencies,
        opts = require("plugins.bufferline").opts,
        config = require("plugins.bufferline").config,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = require("plugins.lualine").init,
        opts = require("plugins.lualine").opts,
    },
    {
        "b0o/incline.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = require("plugins.incline").dependencies,
        config = require("plugins.incline").config,
    },
    {
        "Bekaboo/dropbar.nvim",
        dependencies = require("plugins.dropbar").dependencies,
        config = require("plugins.dropbar").config,
    },
    {
        "Bekaboo/deadcolumn.nvim",
        event = "BufRead",
    },
    -- {
    --     "tadaa/vimade",
    --     event = "VeryLazy",
    --     opts = {
    --         ncmode = "windows",
    --         fadelevel = 0.75,
    --     },
    -- },
    -- NOTE: Usage
    {
        "ggandor/leap.nvim",
        dependencies = require("plugins.leap").dependencies,
        config = require("plugins.leap").config,
    },
    {
        "aserowy/tmux.nvim",
        opts = require("plugins.tmux").opts,
        keys = require("plugins.tmux").keys,
    },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = require("plugins.mini_ai").opts,
        config = require("plugins.mini_ai").config,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = require("plugins.autopairs").dependencies,
        config = require("plugins.autopairs").config,
    },
    {
        "kylechui/nvim-surround",
        event = "BufRead",
        config = true,
    },
    {
        "monaqa/dial.nvim",
        event = "BufRead",
        config = require("plugins.dial").config,
    },
    {
        "NMAC427/guess-indent.nvim",
        event = "BufReadPre",
        config = true,
    },
    {
        "NvChad/nvim-colorizer.lua",
        ft = { "html", "css", "javascript", "vim", "lua", "sh", "zsh", "rust", "conf", "cpp", "nix", "yaml" },
        config = require("plugins.colorizer").config,
    },
    {
        "kevinhwang91/nvim-bqf",
        event = "BufRead",
        opts = {
            auto_enable = true,
            auto_resize_height = true,
        },
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
        event = "BufRead",
        dependencies = "kevinhwang91/promise-async",
        config = require("plugins.ufo").config,
        keys = require("plugins.ufo").keys,
    },
    {
        "kevinhwang91/nvim-hlslens",
        lazy = true,
        keys = require("plugins.hlslens").keys,
        config = require("plugins.hlslens").config,
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = require("plugins.oil").keys,
        opts = require("plugins.oil").opts,
        config = require("plugins.oil").config,
    },
    {
        "mbbill/undotree",
        lazy = true,
        cmd = {
            "UndotreeToggle",
            "UndotreeShow",
            "UndotreePersistUndo",
            "UndotreeHide",
        },
        keys = {
            {
                "<leader>uu",
                function()
                    vim.api.nvim_command("UndotreeToggle")
                end,
                desc = "Undotree Toggle",
            },
        },
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_ShortIndicators = 1
        end,
    },
    {
        "kwkarlwang/bufjump.nvim",
        lazy = true,
        opts = {},
        keys = {
            {
                "<M-n>",
                function()
                    require("bufjump").forward()
                end,
                "Jumplist forward",
            },
            {
                "<M-p>",
                function()
                    require("bufjump").backward()
                end,
                "Jumplist backward",
            },
            {
                "<M-i>",
                function()
                    require("bufjump").forward_same_buf()
                end,
                "Jumplist forward same buffer",
            },
            {
                "<M-o>",
                function()
                    require("bufjump").backward_same_buf()
                end,
                "Jumplist backward same buffer",
            },
        },
    },
    {
        -- NOTE: Until this features gets implemented in core
        "jake-stewart/auto-cmdheight.nvim",
        lazy = false,
        opts = {
            -- max cmdheight before displaying hit enter prompt.
            max_lines = 5,
            -- number of seconds until the cmdheight can restore.
            duration = 2,
            -- whether key press is required to restore cmdheight.
            remove_on_key = true,
            -- always clear the cmdline after duration and key press.
            -- by default it will only happen when cmdheight changed.
            clear_always = false,
        },
    },
    -- NOTE: Git
    {
        "tpope/vim-fugitive",
        event = "BufRead",
        keys = require("plugins.fugitive").keys,
    },
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
        keys = require("plugins.diffview").keys,
    },
    {
        "NeogitOrg/neogit",
        branch = "master",
        cmd = "Neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            -- "nvim-telescope/telescope.nvim",
        },
        config = true,
        keys = require("plugins.neogit").keys,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        cmd = "Gitsigns",
        opts = require("plugins.gitsigns").opts,
        keys = require("plugins.gitsigns").keys,
    },
    {
        "numToStr/Comment.nvim",
        event = "User FileOpened",
        keys = require("plugins.comment").keys,
        opts = require("plugins.comment").opts,
    },
    -- NOTE: Keymaps
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cmd = "WhichKey",
        config = require("plugins.whichkey").config,
    },

    -- NOTE: Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- event = { "LazyFile", "VeryLazy" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        dependencies = require("plugins.treesitter").dependencies,
        init = require("plugins.treesitter").init,
        keys = require("plugins.treesitter").keys,
        opts = require("plugins.treesitter").opts,
        config = require("plugins.treesitter").config,
    },
    -- Show context of the current function
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufRead",
        enabled = false,
        opts = { enable = false, mode = "cursor", trim_scope = "outer", max_lines = 4 },
        keys = {
            {
                "<leader>Ot",
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
            "rust",
        },
        opts = {},
    },
    -- {
    --     "rayliwell/tree-sitter-rstml",
    --     dependencies = { "nvim-treesitter" },
    --     build = ":TSUpdate",
    --     config = function()
    --         require("tree-sitter-rstml").setup()
    --     end,
    -- },
    {
        "m-demare/hlargs.nvim",
        event = "BufRead",
        -- opts = { color = "#f38ba8" },
    },
    -- NOTE: Completion
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        event = "InsertEnter",
        build = (not jit.os:find("Windows"))
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        dependencies = require("plugins.completion").luasnip.dependencies,
        opts = require("plugins.completion").luasnip.opts,
        config = require("plugins.completion").luasnip.config,
    },
    {
        "saghen/blink.cmp",
        -- NOTE: This seems to impact startup time?
        -- lazy = false, -- lazy loading handled internally
        event = { "InsertEnter", "CmdlineEnter" },
        build = "nix run .#build-plugin --accept-flake-config",
        dependencies = require("plugins.completion").blink.dependencies,
        opts = require("plugins.completion").blink.opts,
        opts_extend = require("plugins.completion").blink.opts_extend,
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
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        event = "InsertEnter",
        keys = require("plugins.lsp.copilot").keys,
        config = require("plugins.lsp.copilot").config,
    },
    {
        "neovim/nvim-lspconfig",
        event = "BufRead",
        dependencies = require("plugins.lsp").dependencies,
        opts = require("plugins.lsp").opts,
        config = require("plugins.lsp").config,
    },
    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        keys = require("plugins.lsp").mason.keys,
        opts = require("plugins.lsp").mason.opts,
        config = require("plugins.lsp").mason.config,
    },
    -- NOTE: LSP Utils
    -- {
    --     "ray-x/lsp_signature.nvim",
    --     event = "BufRead",
    --     config = function()
    --         require("lsp_signature").setup({
    --             floating_window = false,
    --             fix_pos = true,
    --             auto_close_after = nil,
    --             hint_enable = true,
    --             hint_prefix = {
    --                 above = "↙ ",
    --                 current = "← ",
    --                 below = "↖ ",
    --             },
    --             toggle_key = "<C-X>",
    --             select_signature_key = "<C-S>",
    --         })
    --     end,
    -- },
    {
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
        config = require("plugins.lsp").lightbulb.config,
    },
    {
        "smjonas/inc-rename.nvim",
        event = "BufRead",
        config = true,
    },
    {
        "Kasama/nvim-custom-diagnostic-highlight",
        event = "BufRead",
        config = true,
    },
    {
        "SmiteshP/nvim-navic",
        enabled = false,
        lazy = true,
        dependencies = require("plugins.lsp").navic.dependencies,
        opts = require("plugins.lsp").navic.opts,
    },
    -- NOTE: Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = require("plugins.debug").dependencies,
        keys = require("plugins.debug").keys,
        config = require("plugins.debug").config,
    },
    -- NOTE: Testing
    {
        "nvim-neotest/neotest",
        dependencies = require("plugins.testing").dependencies,
        opts = require("plugins.testing").opts,
        config = require("plugins.testing").config,
        keys = require("plugins.testing").keys,
    },
    -- NOTE: Trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        keys = require("plugins.trouble").keys,
        opts = require("plugins.trouble").opts,
        specs = require("plugins.trouble").specs,
    },

    -- NOTE: Writing
    -- jbyuki/nabla.nvim
    -- Latex Notes
    --  - https://castel.dev/post/lecture-notes-1/
    {
        "folke/zen-mode.nvim",
        ft = { "txt", "markdown", "norg", "tex", "typ" },
        cmd = "ZenMode",
        opts = require("plugins.zenmode").opts,
        config = true,
    },
    -- NOTE: Latex
    {
        "lervag/vimtex",
        lazy = false,
        config = function()
            vim.g["vimtex_view_method"] = "zathura"
        end,
    },
    {
        "jbyuki/nabla.nvim",
        lazy = true,
        -- ft = { "markdown", "tex", "typ", "typst" },
        keys = {
            {
                "<leader>np",
                function()
                    require("nabla").popup()
                end,
                desc = "Popup latex equation",
            },
        },
    },
    -- NOTE: Markdown
    {
        "MeanderingProgrammer/markdown.nvim",
        main = "render-markdown",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons",
        },
        opts = {
            latex = {
                -- Whether LaTeX should be rendered, mainly used for health check
                enabled = false,
            },
            -- NOTE: Uncomment to get inline latex rendering (doesn't work that well)
            -- win_options = { conceallevel = { rendered = 2 } },
            -- on = {
            --     attach = function()
            --         require("nabla").enable_virt({ autogen = true })
            --     end,
            -- },
        },
    },
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
    -- NOTE: Notes
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        lazy = true,
        event = {
            "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**.md",
            "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/**.md",
        },
        dependencies = require("plugins.obsidian").dependencies,
        opts = require("plugins.obsidian").opts,
        keys = require("plugins.obsidian").keys,
    },
    -- NOTE: Typst
    {
        "kaarmu/typst.vim",
        ft = "typst",
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "0.1.*",
        build = function()
            require("typst-preview").update()
        end,
    },
    -- NOTE: Database
    {
        "chrisbra/csv.vim",
        ft = "csv",
    },
}
