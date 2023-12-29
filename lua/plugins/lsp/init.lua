local util = require("config.functions")

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
                require("telescope.builtin").lsp_definitions({ reuse_win = true })
            end,
            desc = "Goto Definition",
            has = "definition",
        },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        {
            "gI",
            function()
                require("telescope.builtin").lsp_implementations({ reuse_win = true })
            end,
            desc = "Goto Implementation",
        },
        {
            "gy",
            function()
                require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
            end,
            desc = "Goto T[y]pe Definition",
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
    }
    -- if util.has_plugin("inc-rename.nvim") then
    if util.plugin.has("inc-rename.nvim") then
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
    local clients = util.lsp.get_clients({ bufnr = buffer })
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
    local opts = util.plugin.opts("nvim-lspconfig")
    local clients = util.lsp.get_clients({ bufnr = buffer })
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
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

M.dependencies = {
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
                    workspace = {
                        checkThirdParty = false,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        },
        omnisharp = {
            keys = {
                {
                    "gd",
                    function()
                        require("omnisharp_extended").telescope_lsp_definitions()
                    end,
                    desc = "Goto Definition",
                    has = "definition",
                },
            },
            -- handlers = {
            -- 	["textDocument/definition"] = require("omnisharp_extended").handler,
            -- },
            settings = {
                enable_roslyn_analyzers = true,
                enable_import_completion = true,
            },
        },
        rust_analyzer = {
            mason = false,
            keys = {
                -- { "<leader>ld", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
                -- { "<leader>la", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
                { "<leader>dR", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
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
        sqlls = {},
        yamlls = {},
        docker_compose_language_service = {},
        dockerls = {},
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    setup = {
        omnisharp = function(_, opts)
            opts.handlers = {
                ["textDocument/definition"] = require("omnisharp_extended").handler,
            }
        end,
        tsserver = function(_, opts)
            require("typescript-tools").setup({})
            return true
        end,
        rust_analyzer = function(_, opts)
            local rust_tools_opts = require("config.functions").plugin.opts("rust-tools.nvim")
            require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
            return true
        end,
        clangd = function(_, opts)
            local clangd_ext_opts = require("config.functions").plugin.opts("clangd_extensions.nvim")
            require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
            return false
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

    -- setup autoformat

    -- setup keymaps
    util.lsp.on_attach(function(client, buffer)
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
    for name, icon in pairs(require("config.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
        util.lsp.on_attach(function(client, buffer)
            if client.supports_method("textDocument/inlayHint") then
                inlay_hint(buffer, true)
            end
        end)
    end

    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
                local icons = require("config.icons").diagnostics
                for d, icon in pairs(icons) do
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

return M
