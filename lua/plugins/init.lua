return {
    -- NOTE: Colorschemes
    {
        "slugbyte/lackluster.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local lackluster = require("lackluster")
            local color = lackluster.color

            -- !must called setup() before setting the colorscheme!
            ---@diagnostic disable-next-line: missing-fields
            lackluster.setup({
                tweak_syntax = {
                    string = color.green, -- lackluster color
                },
            })

            -- FIXME: Cursorline highlight breaks when opening Snacks.picker a second time

            -- !must set colorscheme after calling setup()!
            -- vim.cmd.colorscheme("lackluster")
        end,
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
            vim.cmd.colorscheme("carbonfox")
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
    {
        "dmtrKovalenko/fff.nvim",
        lazy = true,
        build = "nix run .#release",
        opts = {
            prompt = require("config.ui").icons.ui.FindFile .. " ",
            preview = {
                show_file_info = true,
            },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("fff").find_files()
                end,
                desc = "Open file picker",
            },
        },
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
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = require("plugins.lualine").init,
        opts = require("plugins.lualine").opts,
    },
    {
        "Bekaboo/dropbar.nvim",
        config = require("plugins.dropbar").config,
    },
    {
        "Bekaboo/deadcolumn.nvim",
        event = "BufRead",
    },
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
        "catgoose/nvim-colorizer.lua",
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
        dependencies = require("plugins.ufo").dependencies,
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
        cmd = require("plugins.undotree").cmd,
        keys = require("plugins.undotree").keys,
        config = require("plugins.undotree").config,
    },
    {
        "kwkarlwang/bufjump.nvim",
        lazy = true,
        keys = require("plugins.bufjump").keys,
        opts = {},
    },
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        keys = require("plugins.kulala").keys,
        opts = require("plugins.kulala").opts,
        init = require("plugins.kulala").init,
    },
    -- NOTE: Git
    {
        "tpope/vim-fugitive",
        event = "BufRead",
        keys = require("plugins.fugitive").keys,
    },
    {
        "sindrets/diffview.nvim",
        cmd = require("plugins.diffview").cmd,
        keys = require("plugins.diffview").keys,
    },
    {
        "NeogitOrg/neogit",
        branch = "master",
        cmd = require("plugins.neogit").cmd,
        dependencies = require("plugins.neogit").dependencies,
        keys = require("plugins.neogit").keys,
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        cmd = require("plugins.gitsigns").cmd,
        opts = require("plugins.gitsigns").opts,
        keys = require("plugins.gitsigns").keys,
    },
    {
        "numToStr/Comment.nvim",
        lazy = true,
        event = "User",
        keys = require("plugins.comment").keys,
        opts = require("plugins.comment").opts,
    },
    -- NOTE: Keymaps
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cmd = require("plugins.whichkey").cmd,
        config = require("plugins.whichkey").config,
    },

    -- NOTE: Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        cmd = require("plugins.treesitter").cmd,
        dependencies = require("plugins.treesitter").dependencies,
        init = require("plugins.treesitter").init,
        keys = require("plugins.treesitter").keys,
        opts = require("plugins.treesitter").opts,
        config = require("plugins.treesitter").config,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },
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
    {
        "m-demare/hlargs.nvim",
        event = "BufRead",
    },
    -- NOTE: Completion
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        event = "InsertEnter",
        build = require("plugins.completion").luasnip.build,
        dependencies = require("plugins.completion").luasnip.dependencies,
        opts = require("plugins.completion").luasnip.opts,
        config = require("plugins.completion").luasnip.config,
    },
    {
        "saghen/blink.cmp",
        -- NOTE: This seems to impact startup time?
        -- lazy = false, -- lazy loading handled internally
        -- FIXME: Required due to https://github.com/Saghen/blink.cmp/issues/2044
        version = "1.*",
        event = { "InsertEnter", "CmdlineEnter" },
        -- build = require("plugins.completion").blink.build,
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
        keys = require("plugins.lsp").keys,
        opts = require("plugins.lsp").opts,
        config = require("plugins.lsp").config,
    },
    {

        "mason-org/mason.nvim",
        -- TODO: Pin to v1 for now
        version = "^1.0.0",
        cmd = "Mason",
        build = ":MasonUpdate",
        keys = require("plugins.lsp").mason.keys,
        opts = require("plugins.lsp").mason.opts,
        config = require("plugins.lsp").mason.config,
    },
    -- NOTE: LSP Utils
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
        config = require("plugins.vimtex").config,
    },
    {
        "jbyuki/nabla.nvim",
        lazy = true,
        keys = require("plugins.nabla").keys,
    },
    -- NOTE: Markdown
    {
        "MeanderingProgrammer/markdown.nvim",
        main = "render-markdown",
        ft = { "markdown" },
        dependencies = require("plugins.markdown").dependencies,
        opts = require("plugins.markdown").opts,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        build = require("plugins.markdown-preview").build,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = { "txt", "markdown", "norg" },
        cmd = "TableModeToggle",
        config = require("plugins.vim-table-mode").config,
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
        build = require("plugins.typst-preview").build,
    },
    -- NOTE: Database
    {
        "chrisbra/csv.vim",
        ft = "csv",
    },
}
