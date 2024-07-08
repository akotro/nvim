return {
    -- NOTE: Colorschemes
    {
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = require("plugins.kanagawa").config,
    },
    -- NOTE: Util
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    -- NOTE: UI
    -- { "echasnovski/mini.starter", version = false, opts = {} },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "rachartier/tiny-devicons-auto-colors.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        config = function()
            local status, kanagawa_colors = pcall(require, "kanagawa.colors")
            if status then
                local colors = kanagawa_colors.setup()
                require("tiny-devicons-auto-colors").setup({
                    colors = colors.palette,
                })
            end
        end,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = require("plugins.dressing").init,
        opts = require("plugins.dressing").opts,
    },
    -- {
    --     "rcarriga/nvim-notify",
    --     event = "VeryLazy",
    --     keys = {
    --         {
    --             "<leader>un",
    --             function()
    --                 require("notify").dismiss({ silent = true, pending = true })
    --             end,
    --             desc = "Dismiss all Notifications",
    --         },
    --     },
    --     opts = {
    --         timeout = 3000,
    --         max_height = function()
    --             return math.floor(vim.o.lines * 0.75)
    --         end,
    --         max_width = function()
    --             return math.floor(vim.o.columns * 0.75)
    --         end,
    --         on_open = function(win)
    --             vim.api.nvim_win_set_config(win, { zindex = 100 })
    --         end,
    --     },
    -- },
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
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufRead",
        opts = require("plugins.indent_blankline").opts,
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = "BufRead",
        init = require("plugins.mini_indentscope").init,
        opts = require("plugins.mini_indentscope").opts,
    },
    -- NOTE: Usage
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
        "RRethy/vim-illuminate",
        event = "BufRead",
        keys = require("plugins.illuminate").keys,
        opts = require("plugins.illuminate").opts,
        config = require("plugins.illuminate").config,
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
        ft = { "html", "css", "javascript", "vim", "lua", "sh", "zsh", "rust" },
        config = require("plugins.colorizer").config,
    },
    {
        "stevearc/overseer.nvim",
        event = "BufRead",
        lazy = true,
        keys = require("plugins.overseer").keys,
        opts = require("plugins.overseer").opts,
        config = require("plugins.overseer").config,
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
        dependencies = require("plugins.oil").dependencies,
        keys = require("plugins.oil").keys,
        opts = require("plugins.oil").opts,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        lazy = true,
        keys = require("plugins.toggleterm").keys,
        opts = require("plugins.toggleterm").opts,
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
        branch = "master",
        cmd = "Neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        cmd = "Gitsigns",
        opts = require("plugins.gitsigns").opts,
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
        enabled = true,
        opts = { enable = true, mode = "cursor", trim_scope = "inner", max_lines = 3 },
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
            "rust",
        },
        opts = {},
    },
    {
        "rayliwell/tree-sitter-rstml",
        dependencies = { "nvim-treesitter" },
        build = ":TSUpdate",
        config = function()
            require("tree-sitter-rstml").setup()
        end,
    },
    {
        "m-demare/hlargs.nvim",
        event = "BufRead",
        opts = { color = "#f38ba8" },
    },
    -- NOTE: Completion
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        build = (not jit.os:find("Windows"))
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        dependencies = require("plugins.completion").luasnip.dependencies,
        opts = require("plugins.completion").luasnip.opts,
        config = require("plugins.completion").luasnip.config,
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
    {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function()
            require("lsp_signature").setup({
                hint_enable = false,
            })
        end,
    },
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
        "dnlhc/glance.nvim",
        cmd = "Glance",
        config = true,
    },
    {
        "Kasama/nvim-custom-diagnostic-highlight",
        event = "BufRead",
        config = true,
    },
    {
        "zbirenbaum/copilot.lua",
        build = ":Copilot auth",
        -- event = "InsertEnter",
        lazy = true,
        cmd = "Copilot",
        keys = require("plugins.lsp").copilot.keys,
        config = require("plugins.lsp").copilot.config,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = require("plugins.lsp").copilot_chat.dependencies,
        opts = require("plugins.lsp").copilot_chat.opts,
        cmd = require("plugins.lsp").copilot_chat.cmd,
        keys = require("plugins.lsp").copilot_chat.keys,
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        name = "lsp_lines.nvim",
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
    -- NOTE: Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = require("plugins.telescope").dependencies,
        opts = require("plugins.telescope").opts,
        keys = require("plugins.telescope").keys,
        lazy = true,
        cmd = "Telescope",
    },
    -- NOTE: Trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        keys = require("plugins.trouble").keys,
        opts = require("plugins.trouble").opts,
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
    {
        "3rd/image.nvim",
        -- enabled = require("config.functions").is_linux(),
        enabled = false,
        ft = { "txt", "markdown", "norg", "tex", "typ" },
        opts = require("plugins.image").opts,
        config = require("plugins.image").config,
    },
    -- NOTE: Latex
    {
        "lervag/vimtex",
        ft = "tex",
        config = function()
            vim.g["vimtex_view_method"] = "zathura"
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
    -- NOTE: Notes
    -- {
    --     "nvim-neorg/neorg",
    --     build = ":Neorg sync-parsers",
    --     ft = { "norg" },
    --     cmd = "Neorg",
    --     dependencies = require("plugins.neorg").dependencies,
    --     opts = require("plugins.neorg").opts,
    -- },
    {
        "epwalsh/obsidian.nvim",
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

    -- NOTE: Web
    -- { "mattn/emmet-vim", ft = { "html", "css", "js" } },
    -- { "manzeloth/live-server", cmd = "LiveServer" },

    -- NOTE: Database
    {
        "chrisbra/csv.vim",
        ft = "csv",
    },
    {
        "tpope/vim-dadbod",
        lazy = true,
        cmd = {
            "DBUIToggle",
            "DBUI",
            "DBUIAddConnection",
            "DBUIFindBuffer",
            "DBUIRenameBuffer",
            "DBUILastQueryInfo",
        },
        dependencies = require("plugins.dadbod").dependencies,
        config = require("plugins.dadbod").config,
    },
}
