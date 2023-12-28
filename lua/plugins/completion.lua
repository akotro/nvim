local M = {}

M.luasnip = {}

M.luasnip.opts = {
    history = true,
    delete_check_events = "TextChanged",
}

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

    local defaults = require("cmp.config.default")()
    return {
        completion = {
            autocomplete = false, -- if false, only trigger completions manually
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
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                elseif luasnip.expandable() then
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
        -- }, {
        --     { name = "buffer" },
        -- }),
        formatting = {
            format = function(_, item)
                local icons = require("config.icons").kinds
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
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
            scrollbar = false,
        },
        experimental = {
            ghost_text = false,
            -- ghost_text = {
            --     hl_group = "CmpGhostText",
            -- },
        },
        sorting = defaults.sorting,
        -- sorting = {
        -- 	priority_weight = 2,
        -- 	comparators = {
        -- 		-- Below is the default comparitor list and order for nvim-cmp
        -- 		cmp.config.compare.offset,
        -- 		-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        -- 		cmp.config.compare.exact,
        -- 		require("copilot_cmp.comparators").prioritize,

        -- 		cmp.config.compare.score,
        -- 		cmp.config.compare.recently_used,
        -- 		cmp.config.compare.locality,
        -- 		cmp.config.compare.kind,
        -- 		cmp.config.compare.sort_text,
        -- 		cmp.config.compare.length,
        -- 		cmp.config.compare.order,
        -- 	},
        -- },
    }
end

function M.cmp.config(_, opts)
    for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
    end

    table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

    require("cmp").setup(opts)
end

return M
