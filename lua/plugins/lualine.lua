local M = {}

function M.init()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
    else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
    end
end

function M.opts()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    return M.setup()
end

function M.setup()
    local functions = require("config.functions")
    local icons = require("config.ui").icons

    local window_width_limit = 100

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
            return vim.o.columns > window_width_limit
        end,
        -- check_git_workspace = function()
        --   local filepath = vim.fn.expand "%:p:h"
        --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
        --   return gitdir and #gitdir > 0 and #gitdir < #filepath
        -- end,
    }

    local colors = {
        bg = "#202328",
        fg = "#bbc2cf",
        yellow = "#ECBE7B",
        cyan = "#008080",
        darkblue = "#081633",
        green = "#98be65",
        orange = "#FF8800",
        violet = "#a9a1e1",
        magenta = "#c678dd",
        purple = "#c678dd",
        blue = "#51afef",
        red = "#ec5f67",
    }

    local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end

    local branch = icons.git.Branch

    local path_mode = 1
    if functions.window.is_portrait_mode() then
        path_mode = 0
    end

    local components = {
        mode = {
            function()
                -- return " " .. icons.ui.Target .. " "
                return " " .. icons.logos.arch .. " "
            end,
            padding = { left = 0, right = 0 },
            color = {},
            cond = nil,
        },
        branch = {
            "b:gitsigns_head",
            icon = branch,
            color = { gui = "bold" },
        },
        filename = {
            "filename",
            color = {},
            cond = nil,
        },
        path = {
            "filename",
            path = path_mode,
        },
        diff = {
            "diff",
            source = diff_source,
            symbols = {
                added = icons.git.LineAdded .. " ",
                modified = icons.git.LineModified .. " ",
                removed = icons.git.LineRemoved .. " ",
            },
            padding = { left = 2, right = 1 },
            diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red },
            },
            cond = nil,
        },
        -- python_env = {
        -- 	function()
        -- 		local utils = require("lvim.core.lualine.utils")
        -- 		if vim.bo.filetype == "python" then
        -- 			local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
        -- 			if venv then
        -- 				local icons = require("nvim-web-devicons")
        -- 				local py_icon, _ = icons.get_icon(".py")
        -- 				return string.format(" " .. py_icon .. " (%s)", utils.env_cleanup(venv))
        -- 			end
        -- 		end
        -- 		return ""
        -- 	end,
        -- 	color = { fg = colors.green },
        -- 	cond = conditions.hide_in_width,
        -- },
        diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
                error = icons.diagnostics.BoldError .. " ",
                warn = icons.diagnostics.BoldWarning .. " ",
                info = icons.diagnostics.BoldInformation .. " ",
                hint = icons.diagnostics.BoldHint .. " ",
            },
            -- cond = conditions.hide_in_width,
        },
        treesitter = {
            function()
                return icons.ui.Tree
            end,
            color = function()
                local buf = vim.api.nvim_get_current_buf()
                local ts = vim.treesitter.highlighter.active[buf]
                return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
            end,
            cond = conditions.hide_in_width,
        },
        lsp = {
            function()
                local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                if #buf_clients == 0 then
                    return "LSP Inactive"
                end

                local buf_ft = vim.bo.filetype
                local buf_client_names = {}
                local copilot_active = false

                -- add client
                for _, client in pairs(buf_clients) do
                    if client.name ~= "null-ls" and client.name ~= "copilot" then
                        table.insert(buf_client_names, client.name)
                    end

                    if client.name == "copilot" then
                        copilot_active = true
                    end
                end

                -- add linters
                local linters = require("plugins.linting").list_linters()
                vim.list_extend(buf_client_names, linters)

                -- add formatters
                local formatters = require("conform").list_formatters(0)
                for _, client in pairs(formatters) do
                    -- print(client.name)
                    table.insert(buf_client_names, client.name)
                end

                -- add copilot
                if copilot_active then
                    table.insert(buf_client_names, icons.git.Octoface)
                end

                local unique_client_names = table.concat(buf_client_names, ", ")
                local unique_client_names_formatted = " " .. unique_client_names .. " "
                local language_servers = string.format("[%s]", unique_client_names_formatted)

                -- if copilot_active then
                -- 	language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
                -- end

                return language_servers
            end,
            color = { gui = "bold" },
            cond = conditions.hide_in_width,
        },
        location = { "location" },
        progress = {
            "progress",
            fmt = function()
                return "%P/%L"
            end,
            color = {},
        },

        spaces = {
            function()
                local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
                return icons.ui.Tab .. " " .. shiftwidth
            end,
            padding = 1,
        },
        encoding = {
            "o:encoding",
            fmt = string.upper,
            color = {},
            cond = conditions.hide_in_width,
        },
        filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
        scrollbar = {
            function()
                local current_line = vim.fn.line(".")
                local total_lines = vim.fn.line("$")
                local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
                local line_ratio = current_line / total_lines
                local index = math.ceil(line_ratio * #chars)
                return chars[index]
            end,
            padding = { left = 0, right = 0 },
            -- color = "SLProgress",
            color = {},
            cond = nil,
        },
        visual_selection = {
            function()
                local fn = vim.fn
                local isVisualMode = fn.mode():find("[Vv]")
                if not isVisualMode then
                    return ""
                end
                local starts = fn.line("v")
                local ends = fn.line(".")
                local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
                return tostring(lines) .. "L " .. tostring(fn.wordcount().visual_chars) .. "C"
            end,
            color = { fg = colors.violet },
        },
    }

    return {
        options = {
            theme = "auto",
            globalstatus = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
            lualine_a = {
                components.mode,
            },
            lualine_b = {
                components.path,
            },
            lualine_c = {
                components.branch,
                components.diff,
                components.python_env,
            },
            lualine_x = {
                components.diagnostics,
                components.lsp,
                components.spaces,
                components.filetype,
            },
            lualine_y = {
                components.visual_selection,
                components.location,
            },
            lualine_z = {
                components.progress,
            },
        },
        inactive_sections = {
            lualine_a = {
                components.mode,
            },
            lualine_b = {
                components.branch,
            },
            lualine_c = {
                components.diff,
                components.python_env,
            },
            lualine_x = {
                components.diagnostics,
                components.lsp,
                components.spaces,
                components.filetype,
            },
            lualine_y = { components.location },
            lualine_z = {
                components.progress,
            },
        },
        tabline = {},
        extensions = {},
    }
end

return M
