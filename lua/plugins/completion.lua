local M = {}

M.luasnip = {}

M.luasnip.dependencies = {
    "rafamadriz/friendly-snippets",
}

M.luasnip.opts = {
    history = true,
    delete_check_events = "TextChanged",
    enable_autosnippets = true,
}

function M.luasnip.config()
    -- friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    local utils = require("config.functions")
    local snippet_path = utils.join_paths(utils.get_config_path(), "snippets")

    require("luasnip.loaders.from_lua").lazy_load({ paths = { snippet_path } })

    local ls = require("luasnip")
    vim.keymap.set({ "i" }, "<C-J>", function()
        if ls.expandable() then
            ls.expand_or_jump()
        elseif ls.jumpable(1) then
            ls.jump(1)
        end
    end, { silent = true })
end

M.cmp = {}

M.cmp.dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "rcarriga/cmp-dap",
    -- "hrsh7th/cmp-nvim-lsp-signature-help",
}

function M.cmp.opts()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local function toggle_autocomplete()
        local current_setting = cmp.get_config().completion.autocomplete
        if current_setting and #current_setting > 0 then
            cmp.setup({ completion = { autocomplete = false } })
            vim.notify("Autocomplete disabled")
        else
            cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
            vim.notify("Autocomplete enabled")
        end
    end
    vim.api.nvim_create_user_command("NvimCmpToggle", toggle_autocomplete, {})

    -- local float_win_opts = require("config.ui").get_float_opts()
    -- local window_opts = {
    --     border = float_win_opts.border,
    --     winhighlight = float_win_opts.winhighlight,
    --     winblend = float_win_opts.winblend,
    --     -- side_padding = 0,
    --     scrollbar = true,
    -- }

    local defaults = require("cmp.config.default")()
    return {
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        completion = {
            completeopt = "menu,menuone,noselect,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-J>"] = cmp.mapping(function(fallback)
                if luasnip.expandable() then
                    luasnip.expand_or_jump()
                elseif luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<C-K>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                elseif has_words_before() then
                    cmp.complete()
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-S-Space>"] = cmp.mapping.abort(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            -- ["<S-CR>"] = cmp.mapping.confirm({
            -- 	behavior = cmp.ConfirmBehavior.Replace,
            -- 	select = true,
            -- }),
            ["<C-CR>"] = function(fallback)
                cmp.abort()
                fallback()
            end,
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            -- { name = "nvim_lsp_signature_help" },
            { name = "luasnip" },
            {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            },
            { name = "path" },
            { name = "buffer" },
            { name = "copilot" },
            { name = "crates" },
            { name = "neorg" },
        }),
        formatting = {
            format = function(_, item)
                local icons = require("config.ui").icons.kinds
                if icons[item.kind] then
                    item.kind = icons[item.kind]
                end
                return item
            end,
        },
        cmdline = {
            enable = true,
        },
        window = {
            -- completion = cmp.config.window.bordered(window_opts),
            -- documentation = cmp.config.window.bordered(window_opts),
        },
        experimental = {
            ghost_text = false,
            -- ghost_text = {
            --     hl_group = "CmpGhostText",
            -- },
        },
        sorting = defaults.sorting,
    }
end

function M.cmp.config(_, opts)
    for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
    end

    table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

    local cmp = require("cmp")
    cmp.setup(opts)

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            {
                name = "cmdline",
                option = {
                    ignore_cmds = { "Man", "!" },
                },
            },
        }),
    })

    -- Setup nvim-dbee
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
            { name = "cmp-dbee" },
            { name = "luasnip", keyword_length = 2 },
            { name = "buffer", keyword_length = 5 },
        },
    })

    -- Setup cmp-dap
    cmp.setup.filetype({ "dap_repl", "dapui_watches", "dapui_hover" }, {
        sources = {
            { name = "dap" },
        },
    })
end

M.blink = {}

M.blink.dependencies = {
    {
        "saghen/blink.compat",
        lazy = true,
        opts = {
            impersonate_nvim_cmp = true,
        },
    },
    "echasnovski/mini.icons",
    "L3MON4D3/LuaSnip",
    "rcarriga/cmp-dap",
    "fang2hou/blink-copilot",
}

---@module "blink.cmp"
---@type blink.cmp.Config
M.blink.opts = {
    keymap = {
        preset = "default",
        ["<C-J>"] = { "snippet_forward", "fallback" },
        ["<C-K>"] = { "snippet_backward", "fallback" },
    },

    snippets = {
        preset = "luasnip",
        -- Function to use when expanding LSP provided snippets
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
        -- Function to use when checking if a snippet is active
        active = function(filter)
            if filter and filter.direction then
                return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
        end,
        -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
        jump = function(direction)
            require("luasnip").jump(direction)
        end,
    },

    -- experimental auto-brackets support
    completion = {
        accept = { auto_brackets = { enabled = true } },

        documentation = {
            auto_show = true,
        },

        menu = {
            draw = {
                components = {
                    kind_icon = {
                        ellipsis = false,
                        text = function(ctx)
                            -- local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                            -- return kind_icon
                            local icons = require("config.ui").icons.kinds
                            if icons[ctx.kind] then
                                return icons[ctx.kind]
                            end
                            return nil
                        end,
                        -- Optionally, you may also use the highlights from mini.icons
                        highlight = function(ctx)
                            local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
    },

    -- experimental signature help support
    ---@diagnostic disable-next-line: missing-fields
    signature = { enabled = true },

    ---@diagnostic disable-next-line: missing-fields
    appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    cmdline = {
        enabled = true,
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
            "lazydev",
            "copilot",
            "crates",
            -- NOTE: Disabled from obsidian.nvim side as it causes error, see https://github.com/epwalsh/obsidian.nvim/issues/770
            "obsidian",
            "obsidian_new",
            "obsidian_tags",
        },

        per_filetype = {
            sql = { "cmp_dbee", "snippets", "buffer" },
            mysql = { "cmp_dbee", "snippets", "buffer" },
            plsql = { "cmp_dbee", "snippets", "buffer" },

            dap_repl = { "cmp_dap" },
            dapui_watches = { "cmp_dap" },
            dapui_hover = { "cmp_dap" },
        },

        providers = {
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
                opts = {
                    -- Local options override global ones
                    -- Final settings: max_completions = 3, max_attempts = 2, kind = "Copilot"
                    max_completions = 3, -- Override global max_completions
                },
            },

            -- dont show LuaLS require statements when lazydev has items
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },

            cmp_dap = {
                name = "dap", -- IMPORTANT: use the same name as you would for nvim-cmp
                module = "blink.compat.source",
            },

            crates = {
                name = "crates",
                module = "blink.compat.source",
            },

            obsidian = {
                name = "obsidian",
                module = "blink.compat.source",
            },
            obsidian_new = {
                name = "obsidian_new",
                module = "blink.compat.source",
            },
            obsidian_tags = {
                name = "obsidian_tags",
                module = "blink.compat.source",
            },

            cmp_dbee = {
                name = "cmp-dbee",
                module = "blink.compat.source",
            },
        },
    },
}

-- allows extending the enabled_providers array elsewhere in your config
-- without having to redefine it
M.blink.opts_extend = {
    "sources.default",
}

return M
