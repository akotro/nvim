local M = {}

function M.opts()
	local functions = require("config.functions")
	local icons = require("config.icons")
	local actions = require("telescope.actions")

	local layout_strategy = "horizontal"
	if functions.window.is_portrait_mode() then
		layout_strategy = "vertical"
	end

	return {
		defaults = {
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = nil,
			layout_strategy = layout_strategy,
			layout_config = {},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-q>"] = function(...)
						actions.smart_send_to_qflist(...)
						actions.open_qflist(...)
					end,
					["<CR>"] = actions.select_default,
					["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
				},
				n = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-q>"] = function(...)
						actions.smart_send_to_qflist(...)
						actions.open_qflist(...)
					end,
					["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
				},
			},
			file_ignore_patterns = {
				".git/",
				".git/*",
				"target/",
				"docs/",
				"vendor/*",
				"%.lock",
				"__pycache__/*",
				"%.sqlite3",
				"%.ipynb",
				"node_modules/*",
				-- "%.jpg",
				-- "%.jpeg",
				-- "%.png",
				"%.svg",
				"%.otf",
				"%.ttf",
				"%.webp",
				".dart_tool/",
				".github/",
				".gradle/",
				".idea/",
				".settings/",
				".vscode/",
				"__pycache__/",
				"build/",
				"env/",
				"gradle/",
				"node_modules/",
				"%.pdb",
				"%.dll",
				"%.class",
				"%.exe",
				"%.cache",
				"%.ico",
				"%.pdf",
				"%.dylib",
				"%.jar",
				"%.docx",
				"%.met",
				"smalljre_*/*",
				".vale/",
				"%.burp",
				"%.mp4",
				"%.mkv",
				"%.rar",
				"%.zip",
				"%.7z",
				"%.tar",
				"%.bz2",
				"%.epub",
				"%.flac",
				"%.tar.gz",
				-- vs files
				".vs/*",
				"packages/*",
				"obj/*",
				"build/*",
			},
			path_display = { "smart" },
			winblend = 0,
			border = {},
			borderchars = nil,
			color_devicons = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		},
		pickers = {
			find_files = {
				hidden = true,
			},
			live_grep = {
				--@usage don't include the filename in the search results
				only_sort_text = true,
			},
			grep_string = {
				only_sort_text = true,
			},
			buffers = {
				initial_mode = "insert",
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},
			planets = {
				show_pluto = true,
				show_moon = true,
			},
			git_files = {
				hidden = true,
				show_untracked = true,
			},
			colorscheme = {
				enable_preview = true,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	}
end

M.dependencies = {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		enabled = vim.fn.executable("make") == 1,
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		-- event = "BufRead",
		lazy = true,
		config = function()
			require("neoclip").setup({
				default_register = "+",
			})
			require("config.functions").on_load("telescope.nvim", function()
				pcall(require("telescope").load_extension, "neoclip")
			end)
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		-- event = "BufRead",
		lazy = true,
		config = function()
			require("config.functions").on_load("telescope.nvim", function()
				pcall(require("telescope").load_extension, "undo")
			end)
		end,
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		-- event = "BufRead",
		lazy = true,
		config = function()
			require("config.functions").on_load("telescope.nvim", function()
				pcall(require("telescope").load_extension, "advanced_git_search")
			end)
		end,
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		-- event = "BufRead",
		lazy = true,
		opts = {
			keywords = {
				TODO = { color = "error" },
			},
		},
		config = true,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},
	},
}

return M
