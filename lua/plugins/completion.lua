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
end

M.cmp = {}

M.cmp.dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
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

    local float_win_opts = require("config.ui").get_float_opts()
    local window_opts = {
        border = float_win_opts.border,
        winhighlight = float_win_opts.winhighlight,
        winblend = float_win_opts.winblend,
        -- side_padding = 0,
        scrollbar = true,
    }

    local defaults = require("cmp.config.default")()
    return {
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
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer" },
            { name = "copilot" },
            -- { name = "nvim_lsp_signature_help" },
            { name = "crates" },
            { name = "neorg" },
        }),
        formatting = {
            format = function(_, item)
                local icons = require("config.ui").icons.kinds
                if icons[item.kind] then
                    item.kind = icons[item.kind]--[[  .. item.kind ]]
                end
                return item
            end,
        },
        cmdline = {
            enable = true,
            options = {
                {
                    type = ":",
                    sources = {
                        { name = "path" },
                        { name = "cmdline" },
                    },
                },
                {
                    type = { "/", "?" },
                    sources = {
                        { name = "buffer" },
                    },
                },
            },
        },
        window = {
            completion = cmp.config.window.bordered(window_opts),
            documentation = cmp.config.window.bordered(window_opts),
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

    -- Setup vim-dadbod
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
            { name = "vim-dadbod-completion" },
            { name = "luasnip", keyword_length = 2 },
            { name = "buffer", keyword_length = 5 },
        },
    })
end

return M
