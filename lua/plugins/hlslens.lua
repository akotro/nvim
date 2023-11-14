local M = {}

-- if Neovim is 0.8.0 before, remap yourself.
function M.nN(char)
	local ok, winid = require("hlslens").nNPeekWithUFO(char)
	if ok and winid then
		-- Safe to override buffer scope keymaps remapped by ufo,
		-- ufo will restore previous buffer keymaps before closing preview window
		-- Type <CR> will switch to preview window and fire `trace` action
		vim.keymap.set("n", "<CR>", function()
			local keyCodes = vim.api.nvim_replace_termcodes("<Tab><CR>", true, false, true)
			vim.api.nvim_feedkeys(keyCodes, "im", false)
		end, { buffer = true })
	end
	-- vim.api.nvim_replace_termcodes("zz", true, false, true)
end

function M.start(char)
	-- vim.api.nvim_replace_termcodes(char, true, false, true)
	require("hlslens").start()
	-- vim.api.nvim_replace_termcodes("zz", true, false, true)
end

local kopts = { noremap = true, silent = true }

M.keys = {
	{
		"n",
		[[<Cmd>lua require("plugins.hlslens").nN('n')<CR>zz]],
		-- function()
		-- 	nN("n")
		-- end,
		mode = { "n", "x" },
	},
	{
		"N",
		[[<Cmd>lua require("plugins.hlslens").nN('N')<CR>zz]],
		-- function()
		-- 	nN("N")
		-- end,
		mode = { "n", "x" },
	},
	-- {
	-- 	"*",
	-- 	-- [[*<Cmd>lua require('hlslens').start()<CR>zz]],
	-- 	function()
	-- 		start("*")
	-- 	end,
	-- 	mode = "",
	-- 	opts = kopts,
	-- },
	-- {
	-- 	"#",
	-- 	-- [[#<Cmd>lua require('hlslens').start()<CR>zz]],
	-- 	function()
	-- 		start("#")
	-- 	end,
	-- 	mode = "",
	-- 	opts = kopts,
	-- },
	-- {
	-- 	"g*",
	-- 	-- [[g*<Cmd>lua require('hlslens').start()<CR>zz]],
	-- 	function()
	-- 		start("g*")
	-- 	end,
	-- 	mode = "",
	-- 	opts = kopts,
	-- },
	-- {
	-- 	"g#",
	-- 	-- [[g#<Cmd>lua require('hlslens').start()<CR>zz]],
	-- 	function()
	-- 		start("g#")
	-- 	end,
	-- 	mode = "",
	-- 	opts = kopts,
	-- },
}

M.opts = {
	override_lens = function(render, posList, nearest, idx, relIdx)
		local sfw = vim.v.searchforward == 1
		local indicator, text, chunks
		local absRelIdx = math.abs(relIdx)
		if absRelIdx > 1 then
			indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
		elseif absRelIdx == 1 then
			indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
		else
			indicator = ""
		end

		local lnum, col = unpack(posList[idx])
		if nearest then
			local cnt = #posList
			if indicator ~= "" then
				text = ("[%s %d/%d]"):format(indicator, idx, cnt)
			else
				text = ("[%d/%d]"):format(idx, cnt)
			end
			chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
		else
			text = ("[%s %d]"):format(indicator, idx)
			chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
		end
		render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
	end,
}

function M.config()
	require("hlslens").setup(M.opts)
end

return M
