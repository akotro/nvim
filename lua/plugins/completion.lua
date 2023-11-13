local M = {}

M.luasnip = {}

M.luasnip.opts = {
	history = true,
	delete_check_events = "TextChanged",
}

M.luasnip.keys = {
	{
		"<c-j>",
		function()
			return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
		end,
		expr = true,
		silent = true,
		mode = "i",
	},
	{
		"<c-j>",
		function()
			require("luasnip").jump(1)
		end,
		mode = "s",
	},
	{
		"<c-k>",
		function()
			require("luasnip").jump(-1)
		end,
		mode = { "i", "s" },
	},
}

M.cmp = {}

function M.cmp.opts()
	vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	-- local has_words_before = function()
	-- 	unpack = unpack or table.unpack
	-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	-- 	return col ~= 0
	-- 		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	-- end

	local defaults = require("cmp.config.default")()
	return {
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			-- ["<Tab>"] = cmp.mapping(function(fallback)
			-- 	if cmp.visible() then
			-- 		-- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
			-- 		cmp.select_next_item()
			-- 	-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
			-- 	-- this way you will only jump inside the snippet region
			-- 	elseif luasnip.expand_or_jumpable() then
			-- 		luasnip.expand_or_jump()
			-- 	elseif has_words_before() then
			-- 		cmp.complete()
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, { "i", "s" }),
			-- ["<S-Tab>"] = cmp.mapping(function(fallback)
			-- 	if cmp.visible() then
			-- 		cmp.select_prev_item()
			-- 	elseif luasnip.jumpable(-1) then
			-- 		luasnip.jump(-1)
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, { "i", "s" }),
			["<tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<s-tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<S-CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
		formatting = {
			format = function(_, item)
				local icons = require("config.icons").kinds
				if icons[item.kind] then
					item.kind = icons[item.kind] .. item.kind
				end
				return item
			end,
		},
		experimental = {
			ghost_text = {
				hl_group = "CmpGhostText",
			},
		},
		sorting = defaults.sorting,
	}
end

function M.cmp.config(_, opts)
	for _, source in ipairs(opts.sources) do
		source.group_index = source.group_index or 1
	end
	require("cmp").setup(opts)
end

return M
