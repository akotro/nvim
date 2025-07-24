local M = {}

M.luasnip = {}

M.build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    or nil

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

M.blink = {}

M.build = "nix run .#build-plugin --accept-flake-config"

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

    fuzzy = { implementation = "prefer_rust_with_warning" },

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
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
        default = {
            "lazydev",
            "lsp",
            "path",
            "snippets",
            "buffer",
            "copilot",
            "crates",
            "obsidian",
            "obsidian_new",
            "obsidian_tags",
        },

        per_filetype = {
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
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority
                score_offset = 100,
            },

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
        },
    },
}

-- allows extending the enabled_providers array elsewhere in your config
-- without having to redefine it
M.blink.opts_extend = {
    "sources.default",
}

return M
