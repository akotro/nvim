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
    -- { "<c-s>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help"},
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
    {
        "<leader>lr",
        function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename",
    },
    -- { "<leader>lr", vim.lsp.buf.rename, desc = "Rename"},

    -- lsp specific

    -- rust_analyzer
    -- { "<leader>ld", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
    -- { "<leader>la", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
    { "<leader>dR", "<cmd>RustLsp debuggables<cr>", desc = "Run Debuggables (Rust)" },

    -- taplo
    {
        "<leader>ld",
        function()
            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                require("crates").show_popup()
            else
                vim.lsp.buf.hover()
            end
        end,
        desc = "Show Crate Documentation",
    },

    -- clangd
    { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
}

M.dependencies = {
    {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
    },
    "mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },

    -- NOTE: LSP Language Extensions

    -- lua
    {
        "folke/lazydev.nvim",
        -- disable when a .luarc.json file is found
        -- enabled = function(root_dir)
        --     return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
        -- end,
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "lazy.nvim",
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

    -- csharp
    -- { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true, ft = "cs" },
    { "Decodetalkers/csharpls-extended-lsp.nvim", lazy = true, ft = "cs" },

    -- rust
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        lazy = false, -- This plugin is already lazy
    },
    {
        "saecki/crates.nvim",
        lazy = true,
        event = { "BufRead Cargo.toml" },
        ft = { "rust", "toml" },
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
                -- cmp = {
                --     enabled = true,
                -- },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },

    -- typescript
    {
        "pmizio/typescript-tools.nvim",
        lazy = true,
        -- ft = { "ts", "tsx", "js", "jsx" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- c, cpp
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

    -- java
    {
        "nvim-java/nvim-java",
        lazy = true,
        opts = {
            jdk = {
                auto_install = false,
            },
        },
    },
}

function M.config(_, opts)
    -- if util.plugin.has("neoconf.nvim") then
    -- 	local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    -- 	require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
    -- end

    local icons = require("config.ui").icons

    -- setup lsp floating window border (override globally)
    -- local border = require("config.ui").get_float_opts().border
    -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    -- function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
    --     options = options or {}
    --     -- options.border = options.border or border
    --     return orig_util_open_floating_preview(contents, syntax, options, ...)
    -- end

    local register_capability = vim.lsp.handlers["client/registerCapability"]

    vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        -- TODO:
        M.on_attach(client, buffer)
        return ret
    end

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

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    if inlay_hint then
        utils.lsp.on_attach(function(client, buffer)
            if client:supports_method("textDocument/inlayHint") then
                inlay_hint.enable(true, { bufnr = buffer })
            end
        end)
    end

    local has_ufo, _ = pcall(require, "ufo")
    local ufo_capabilities = vim.lsp.protocol.make_client_capabilities()
    if has_ufo then
        ufo_capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
    end
    -- local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local has_blink, blink_cmp = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        -- has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_ufo and ufo_capabilities or {},
        has_blink and blink_cmp.get_lsp_capabilities(nil, true) or {},
        {}
    )

    -- lua_ls
    local lua_ls_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
    }, {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    })
    vim.lsp.config("lua_ls", lua_ls_opts)
    vim.lsp.enable("lua_ls")

    -- csharp_ls
    vim.lsp.enable("csharp_ls")
    require("csharpls_extended").buf_read_cmd_bind()

    -- tsserver
    require("typescript-tools").setup({})

    -- rust_analyzer
    local rust_analyzer_opts = {
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
            },
        },
    }
    vim.lsp.config("rust_analyzer", rust_analyzer_opts)
    vim.lsp.enable("rust_analyzer")
    vim.g.rustaceanvim = {
        server = {
            on_attach = function(_, bufnr)
                local rustacean_keys = {
                    -- { "<leader>ld", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
                    -- { "<leader>la", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
                    { "<leader>dR", "<cmd>RustLsp debuggables<cr>", desc = "Run Debuggables (Rust)" },
                }
                local lazy_keys = require("lazy.core.handler.keys")

                for _, keys in pairs(rustacean_keys) do
                    if not keys.has or M.has(bufnr, keys.has) then
                        local key_opts = lazy_keys.opts(keys)
                        keys.lhs = keys[1]
                        keys.rhs = keys[2]
                        key_opts.has = nil
                        key_opts.silent = key_opts.silent ~= false
                        key_opts.buffer = bufnr
                        vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, key_opts)
                    end
                end
            end,
            default_settings = opts.settings,
        },
    }

    -- taplo
    vim.lsp.enable("taplo")

    -- clangd
    local clangd_opts = {
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
                "Makefile",
                "configure.ac",
                "configure.in",
                "config.h.in",
                "meson.build",
                "meson_options.txt",
                "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                fname
            ) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        capabilities = {
            offsetEncoding = { "utf-16" },
        },
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
    }
    vim.lsp.config("clangd", clangd_opts)
    vim.lsp.enable("clangd")
    local clangd_ext_opts = require("config.functions").plugin.opts("clangd_extensions.nvim")
    require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))

    -- tailwindcss
    vim.lsp.enable("tailwindcss")

    -- svelte
    vim.lsp.enable("svelte")

    -- jsonls
    vim.lsp.enable("jsonls")

    -- lemminx
    vim.lsp.enable("lemminx")

    -- bashls
    vim.lsp.enable("bashls")

    -- nushell
    vim.lsp.enable("nushell")

    -- pyright
    local pyright_opts = {
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
    }
    vim.lsp.config("pyright", pyright_opts)
    vim.lsp.enable("pyright")

    -- yamlls
    vim.lsp.enable("yamlls")

    -- docker_compose_language_service
    local docker_compose_language_service_opts = {
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern("docker-compose.yaml", "docker-compose.yml")(fname)
        end,
    }
    vim.lsp.config("docker_compose_language_service", docker_compose_language_service_opts)
    vim.lsp.enable("docker_compose_language_service")
    vim.filetype.add({
        filename = {
            ["docker-compose.yml"] = "yaml.docker-compose",
            ["docker-compose.yaml"] = "yaml.docker-compose",
            ["compose.yml"] = "yaml.docker-compose",
            ["compose.yaml"] = "yaml.docker-compose",
        },
    })

    -- dockerls
    vim.lsp.enable("dockerls")

    -- texlab
    vim.lsp.enable("texlab")

    -- tinymist
    local tinymist_opts = {
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern("*.typ")(fname)
        end,
    }
    vim.lsp.config("tinymist", tinymist_opts)
    vim.lsp.enable("tinymist")
    vim.filetype.add({
        filename = {
            ["*.typ"] = "typst",
        },
    })

    -- nixd
    vim.lsp.enable("nixd")

    -- zls
    vim.lsp.enable("zls")

    -- jdtls
    local jdtls_opts = {
        java = {
            format = {
                settings = {
                    url = "~/.config/java/eclipse-java-google-style.xml",
                },
            },
        },
    }
    vim.lsp.config("jdtls", jdtls_opts)
    vim.lsp.enable("jdtls")

    -- harper_ls
    local harper_ls_opts = {
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
    }
    vim.lsp.config("harper_ls", harper_ls_opts)
    vim.lsp.enable("harper_ls")

    -- prolog_ls
    vim.lsp.enable("prolog_ls")

    -- local ensure_installed = {} ---@type string[]
    -- for server, server_opts in pairs(servers) do
    --     if server_opts then
    --         server_opts = server_opts == true and {} or server_opts
    --         if server_opts.enabled ~= false then
    --             -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
    --             if configure(server) then
    --                 exclude_automatic_enable[#exclude_automatic_enable + 1] = server
    --             else
    --                 ensure_installed[#ensure_installed + 1] = server
    --             end
    --         end
    --     end
    -- end

    -- if have_mason then
    --     mlsp.setup({ ensure_installed = ensure_installed, exclude = exclude_automatic_enable })
    -- end

    -- if utils.lsp.get_config("denols") and utils.lsp.get_config("tsserver") then
    --     local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    --     utils.lsp.disable("tsserver", is_deno)
    --     utils.lsp.disable("denols", function(root_dir)
    --         return not is_deno(root_dir)
    --     end)
    -- end
end

M.mason = require("plugins.lsp.mason")

M.lightbulb = require("plugins.lsp.lightbulb")

M.navic = require("plugins.lsp.navic")

M.copilot = require("plugins.lsp.copilot")

-- M.copilot_chat = require("plugins.lsp.copilot_chat")

return M
