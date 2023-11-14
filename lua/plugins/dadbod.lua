local M = {}

local function db_completion()
	require("cmp").setup.buffer({
		sources = {
			{ name = "vim-dadbod-completion" },
			{ name = "luasnip", keyword_length = 2 },
			{ name = "buffer", keyword_length = 5 },
		},
	})
end

function M.setup()
	vim.g.db_ui_save_location = vim.fn.stdpath("data") .. require("plenary.path").path.sep .. "db_ui"
	vim.g.db_ui_execute_on_save = 0

	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"sql",
			"mysql",
			"plsql",
		},
		callback = function()
			vim.schedule(db_completion)
		end,
	})
end

return M
