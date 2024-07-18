local utils = require("config.functions")

local M = {}

M._keys = nil

function M.get()
    if M._keys then
        return M._keys
    end
    M._keys = {
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        {
            "gd",
            function()
                require("plugins.trouble").lspGoTo("lsp_definitions")
            end,
            desc = "Goto Definitions",
            has = "definition",
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
            "gp",
            function()
                require("config.functions").open_plugin_github()
            end,
            desc = "Goto Plugin Github",
        },
        { "<leader>ld", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>lD", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
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
            has = "codeAction",
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
        {
            "<leader>lv",
            function()
                require("lsp_lines").toggle()
            end,
            desc = "Virtual Text",
        },
        {
            "<leader>ll",
            function()
                vim.lsp.codelens.run()
            end,
            desc = "CodeLens Action",
        },
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
            "<cmd>Telescope lsp_document_symbols<cr>",
            desc = "Document Symbols",
        },
        {
            "<leader>lS",
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
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
            "<leader>lL",
            function()
                require("lsp_lines").toggle()
            end,
            desc = "LSP Lines",
        },
        {
            "<leader>lu",
            "<cmd>LuaSnipUnlinkCurrent<cr>",
            desc = "Unlink Snippet",
        },
    }
    if utils.plugin.has("inc-rename.nvim") then
        M._keys[#M._keys + 1] = {
            "<leader>lr",
            function()
                local inc_rename = require("inc_rename")
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end,
            expr = true,
            desc = "Rename",
            has = "rename",
        }
    else
        M._keys[#M._keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    end
    return M._keys
end

---@param method string
function M.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = utils.lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
    local Keys = require("lazy.core.handler.keys")
    if not Keys.resolve then
        return {}
    end
    local spec = M.get()
    local opts = utils.plugin.opts("nvim-lspconfig")
    local clients = utils.lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
    end
    return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = M.resolve(buffer)

    for _, keys in pairs(keymaps) do
        if not keys.has or M.has(buffer, keys.has) then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            opts.remap = false
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

M.dependencies = {
    {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
    },
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },

    -- NOTE: LSP Language Extensions

    -- lua
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "lazy.nvim",
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
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
        ft = { "rust", "toml" },
        opts = {
            completion = {
                cmp = {
                    enabled = true,
                },
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
}

M.opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        virtual_lines = false, -- disable by default
        -- virtual_text = {
        -- 	spacing = 4,
        -- 	source = "if_many",
        -- 	prefix = "●",
        -- 	-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- 	-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- 	-- prefix = "icons",
        -- },
        severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
        enabled = false,
    },
    -- add any global capabilities here
    capabilities = {},
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
        formatting_options = nil,
        timeout_ms = nil,
    },
    -- LSP Server Settings
    servers = {
        lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- keys = {},
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
        },
        -- omnisharp = {
        --     keys = {
        --         {
        --             "gd",
        --             function()
        --                 require("omnisharp_extended").telescope_lsp_definitions()
        --             end,
        --             desc = "Goto Definition",
        --             has = "definition",
        --         },
        --     },
        --     settings = {
        --         enable_roslyn_analyzers = true,
        --         enable_import_completion = true,
        --     },
        -- },
        csharp_ls = {},
        rust_analyzer = {
            mason = false,
            keys = {
                -- { "<leader>ld", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
                -- { "<leader>la", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
                { "<leader>dR", "<cmd>RustLsp debuggables<cr>", desc = "Run Debuggables (Rust)" },
            },
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
        },
        taplo = {
            keys = {
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
            },
        },
        clangd = {
            keys = {
                { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            },
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern(
                    "Makefile",
                    "configure.ac",
                    "configure.in",
                    "config.h.in",
                    "meson.build",
                    "meson_options.txt",
                    "build.ninja"
                )(fname) or require("lspconfig.util").root_pattern(
                    "compile_commands.json",
                    "compile_flags.txt"
                )(fname) or require("lspconfig.util").find_git_ancestor(fname)
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
        },
        tsserver = {},
        tailwindcss = {},
        svelte = {},
        jsonls = {},
        lemminx = {},
        bashls = {},
        nushell = {},
        pyright = {},
        -- sqlls = {},
        -- sqls = {
        --     mason = false,
        -- },
        yamlls = {},
        docker_compose_language_service = {
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern("docker-compose.yaml", "docker-compose.yml")(fname)
            end,
        },
        dockerls = {},
        texlab = {},
        typst_lsp = {
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern("*.typ")(fname)
            end,
        },
        nil_ls = {
            mason = false,
            settings = {
                ["nil"] = {
                    autoArchive = true,
                },
            },
        },
        zls = {},
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    setup = {
        -- omnisharp = function(_, opts)
        --     opts.handlers = {
        --         ["textDocument/definition"] = require("omnisharp_extended").handler,
        --     }
        -- end,
        csharp_ls = function(_, opts)
            opts.handlers = {
                ["textDocument/definition"] = require("csharpls_extended").handler,
                ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
            }
        end,
        tsserver = function(_, opts)
            require("typescript-tools").setup({})
            return true
        end,
        rust_analyzer = function(_, opts)
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                        local Keys = require("lazy.core.handler.keys")

                        for _, keys in pairs(opts.keys) do
                            if not keys.has or M.has(bufnr, keys.has) then
                                local key_opts = Keys.opts(keys)
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
            return true
        end,
        clangd = function(_, opts)
            local clangd_ext_opts = require("config.functions").plugin.opts("clangd_extensions.nvim")
            require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
            return false
        end,
        docker_compose_language_service = function(_, _)
            vim.filetype.add({
                filename = {
                    ["docker-compose.yml"] = "yaml.docker-compose",
                    ["docker-compose.yaml"] = "yaml.docker-compose",
                    ["compose.yml"] = "yaml.docker-compose",
                    ["compose.yaml"] = "yaml.docker-compose",
                },
            })
        end,
        typst_lsp = function(_, _)
            vim.filetype.add({
                filename = {
                    ["*.typ"] = "typst",
                },
            })
        end,
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
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
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
        options = options or {}
        -- options.border = options.border or border
        return orig_util_open_floating_preview(contents, syntax, options, ...)
    end

    -- setup keymaps
    utils.lsp.on_attach(function(client, buffer)
        M.on_attach(client, buffer)
    end)

    local register_capability = vim.lsp.handlers["client/registerCapability"]

    vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        M.on_attach(client, buffer)
        return ret
    end

    -- diagnostics
    for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
        utils.lsp.on_attach(function(client, buffer)
            if client.supports_method("textDocument/inlayHint") then
                inlay_hint.enable(true, { bufnr = buffer })
            end
        end)
    end

    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
                for d, icon in pairs(icons.diagnostics) do
                    if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                        return icon
                    end
                end
            end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
    )

    local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
                return
            end
        elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
                return
            end
        end
        require("lspconfig")[server].setup(server_opts)
    end

    -- get all the servers that are available through mason-lspconfig
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local all_mslp_servers = {}
    if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    end

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
        if server_opts then
            server_opts = server_opts == true and {} or server_opts
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                setup(server)
            else
                ensure_installed[#ensure_installed + 1] = server
            end
        end
    end

    if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end

    -- if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
    -- 	local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    -- 	Util.lsp.disable("tsserver", is_deno)
    -- 	Util.lsp.disable("denols", function(root_dir)
    -- 		return not is_deno(root_dir)
    -- 	end)
    -- end
end

M.mason = require("plugins.lsp.mason")

M.lightbulb = require("plugins.lsp.lightbulb")

M.copilot = require("plugins.lsp.copilot")

M.copilot_chat = require("plugins.lsp.copilot_chat")

return M
