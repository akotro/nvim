local utils = require("config.functions")

local M = {}

M.keys = {
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    {
        "gd",
        function()
            require("plugins.trouble").lspGoTo("lsp_definitions")
        end,
        desc = "Goto Definitions",
    },
    {
        "gr",
        function()
            require("plugins.trouble").lspGoTo("lsp_references")
        end,
        desc = "Goto References",
    },
    {
        "gD",
        function()
            require("plugins.trouble").lspGoTo("lsp_declarations")
        end,
        desc = "Goto Declaration",
    },
    {
        "gI",
        function()
            require("plugins.trouble").lspGoTo("lsp_implementations")
        end,
        desc = "Goto Implementation",
    },
    {
        "gy",
        function()
            require("plugins.trouble").lspGoTo("lsp_type_definitions")
        end,
        desc = "Goto Type Definition",
    },
    {
        "gic",
        function()
            require("plugins.trouble").lspGoTo("lsp_incoming_calls")
        end,
        desc = "Goto Incoming Calls",
    },
    {
        "goc",
        function()
            require("plugins.trouble").lspGoTo("lsp_outgoing_calls")
        end,
        desc = "Goto Outgoing Calls",
    },
    {
        "gB",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Goto Git Remote",
    },
    { "<leader>ld", vim.lsp.buf.hover, desc = "Hover" },
    { "<leader>lD", vim.lsp.buf.signature_help, desc = "Signature Help" },
    -- { "<c-s>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    {
        "<leader>lA",
        function()
            vim.lsp.buf.code_action({
                context = {
                    only = {
                        "source",
                    },
                    diagnostics = {},
                },
            })
        end,
        desc = "Source Action",
    },
    {
        "<leader>lc",
        "<cmd>NvimCmpToggle<CR>",
        desc = "Toggle Autocomplete",
    },
    {
        "<leader>lw",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics",
    },
    {
        "<leader>lh",
        function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ filter = nil }))
        end,
        desc = "Toggle Hints",
    },
    {
        "<leader>lH",
        "<cmd>IlluminationToggle<cr>",
        desc = "Toggle Doc HL",
    },
    {
        "<leader>lI",
        "<cmd>LspInstallInfo<cr>",
        desc = "Installer Info",
    },
    {
        "<leader>lj",
        function()
            vim.diagnostic.jump({ count = 1, float = false })
        end,
        desc = "Next Diagnostic",
    },
    {
        "<leader>lk",
        function()
            vim.diagnostic.jump({ count = -1, float = false })
        end,
        desc = "Prev Diagnostic",
    },
    -- {
    --     "<leader>ll",
    --     function()
    --         vim.lsp.codelens.run()
    --     end,
    --     desc = "CodeLens Action",
    -- },
    -- {
    --     "<leader>lo",
    --     "<cmd>SymbolsOutline<cr>",
    --     "Outline",
    -- },
    {
        "<leader>lq",
        function()
            vim.lsp.diagnostic.set_loclist()
        end,
        desc = "Quickfix",
    },
    {
        "<leader>lr",
        function()
            return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename",
    },
    {
        "<leader>lR",
        "<cmd>Trouble lsp_references toggle focus=false<cr>",
        desc = "References",
    },
    {
        "<leader>ls",
        -- "<cmd>Telescope lsp_document_symbols<cr>",
        function()
            Snacks.picker.lsp_symbols()
        end,
        desc = "Document Symbols",
    },
    {
        "<leader>lS",
        -- "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        function()
            Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
    },
    {
        "<leader>lt",
        function()
            utils.toggle_diagnostics()
        end,
        desc = "Toggle Diagnostics",
    },
    {
        "<leader>lo",
        function()
            -- utils.open_diagnostic()
            vim.diagnostic.open_float()
        end,
        desc = "Open Diagnostic Float",
    },
    {
        "<leader>ll",
        function()
            local new_config = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_config })
        end,
        desc = "LSP Lines",
    },
    {
        "<leader>lL",
        function()
            local new_config = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_config })
        end,
        desc = "LSP Lines",
    },
    {
        "<leader>lu",
        "<cmd>LuaSnipUnlinkCurrent<cr>",
        desc = "Unlink Snippet",
    },
}
M.dependencies = {
    { "j-hui/fidget.nvim", opts = {} },
}

function M.config()
    local icons = require("config.ui").icons

    -- diagnostics
    ---@type vim.diagnostic.Opts
    local diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        virtual_lines = false, -- disable by default
        severity_sort = true,
    }

    for name, icon in pairs(icons.diagnostics) do
        local severity = vim.diagnostic.severity[name:upper()]

        if severity then
            if not diagnostics.signs then
                diagnostics.signs = {}
            end
            if not diagnostics.signs.text then
                diagnostics.signs.text = {}
            end

            diagnostics.signs.text[severity] = icon

            local sign_name = "DiagnosticSign" .. name
            vim.fn.sign_define(sign_name, { text = icon, texthl = sign_name, numhl = "" })
        end
    end

    vim.diagnostic.config(vim.deepcopy(diagnostics))

    vim.lsp.config("lua_ls", {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath("config")
                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        "lua/?.lua",
                        "lua/?/init.lua",
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths
                        -- here.
                        -- '${3rd}/luv/library'
                        -- '${3rd}/busted/library'
                    },
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = {
                    --   vim.api.nvim_get_runtime_file('', true),
                    -- }
                },
                codeLens = {
                    enable = true,
                },
                completion = {
                    callSnippet = "Replace",
                },
                doc = {
                    privateName = { "^_" },
                },
                hint = {
                    enable = true,
                    setType = false,
                    paramType = true,
                    paramName = "Disable",
                    semicolon = "Disable",
                    arrayIndex = "Disable",
                },
            })
        end,
        settings = {
            Lua = {},
        },
    })

    vim.lsp.config("rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                -- Add clippy lints for Rust.
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
                -- files = {
                --     excludeDirs = { ".direnv" },
                -- },
            },
        },
    })

    vim.lsp.config("clangd", {
        on_init = function(client)
            local clangd_ext_opts = require("config.functions").plugin.opts("clangd_extensions.nvim")
            require("clangd_extensions").setup(
                vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = client.config })
            )
        end,
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
        },
    })

    vim.lsp.config("tsserver", {
        on_init = function(_)
            require("typescript-tools").setup({})
        end,
    })

    vim.lsp.config("bashls", {
        filetypes = { "bash", "sh", "zsh" },
    })

    vim.lsp.config("pyright", {
        settings = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { "*" },
                },
            },
        },
    })

    vim.lsp.config("docker_compose_language_service", {
        on_init = function()
            vim.filetype.add({
                filename = {
                    ["docker-compose.yml"] = "yaml.docker-compose",
                    ["docker-compose.yaml"] = "yaml.docker-compose",
                    ["compose.yml"] = "yaml.docker-compose",
                    ["compose.yaml"] = "yaml.docker-compose",
                },
            })
        end,
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern("docker-compose.yaml", "docker-compose.yml")(fname)
        end,
    })

    vim.lsp.config("tinymist", {
        -- on_init = function()
        --     vim.filetype.add({
        --         filename = {
        --             ["*.typ"] = "typst",
        --         },
        --     })
        -- end,
    })

    vim.lsp.config("harper_ls", {
        filetypes = {
            "markdown",
            "txt",
            "html",
            -- "gitcommit",
            -- "rust",
            -- "typescript",
            -- "typescriptreact",
            -- "javascript",
            -- "python",
            -- "go",
            -- "c",
            -- "cpp",
            -- "ruby",
            -- "swift",
            -- "cs",
            -- "toml",
            -- "lua",
            -- "java",
        },
    })

    vim.lsp.config("html", {
        filetypes = {
            "html",
            "templ",
            "cshtml",
            "razor",
        },
    })

    vim.lsp.enable({
        "lua_ls",
        "roslyn",
        -- NOTE: rustaceanvim already sets this up
        -- "rust_analyzer",
        "taplo",
        "clangd",
        "tsserver",
        "tailwindcss",
        "svelte",
        "jsonls",
        "lemminx",
        "bashls",
        "nushell",
        "pyright",
        "yamlls",
        "docker_compose_language_service",
        "dockerls",
        "texlab",
        "tinymist",
        "nixd",
        "zls",
        "jdtls",
        "harper_ls",
        "prolog_ls",
        "kulala_ls",
        "html",
    })
end

M.mason = require("plugins.lsp.mason")

M.lightbulb = require("plugins.lsp.lightbulb")

M.navic = require("plugins.lsp.navic")

M.copilot = require("plugins.lsp.copilot")

return M
