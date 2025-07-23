local M = {}

---@module "snacks"

M.dependencies = {
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "BufRead",
        lazy = true,
        opts = {
            keywords = {
                TODO = { color = "error", alt = { "todo", "unimplemented", "IMPORTANT" } },
            },
            highlight = {
                pattern = {
                    [[.*<(KEYWORDS)\s*:]],
                    [[.*<(KEYWORDS)\s*!\(]],
                },
                comments_only = false,
            },
            search = {
                pattern = [[\b(KEYWORDS)(:|!\()]],
            },
        },
        config = true,
        keys = {
            {
                "<leader>ft",
                function()
                    Snacks.picker.todo_comments()
                end,
                desc = "Todo",
            },
            {
                "<leader>fT",
                function()
                    Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
                end,
                desc = "Todo/Fix/Fixme",
            },
            -- {
            --     "]t",
            --     function()
            --         require("todo-comments").jump_next()
            --     end,
            --     desc = "Next todo comment",
            -- },
            -- {
            --     "[t",
            --     function()
            --         require("todo-comments").jump_prev()
            --     end,
            --     desc = "Previous todo comment",
            -- },
        },
    },
}

local target_term_id = vim.v.count1

---@type snacks.Config
M.opts = {
    bigfile = { enabled = true },

    quickfile = { enabled = true },

    -- notifier = {
    --     enabled = true,
    --     timeout = 3000,
    -- },

    statuscolumn = { enabled = true },

    words = { enabled = true },

    indent = {
        filter = function(buf)
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
    },

    input = { enabled = true },

    scroll = {
        enabled = false,
        animate = {
            duration = { step = 5, total = 50 },
            easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
            delay = 100, -- delay in ms before using the repeat animation
            duration = { step = 2, total = 20 },
            easing = "linear",
        },
    },

    styles = {
        ---@diagnostic disable-next-line: missing-fields
        notification = {
            wo = { wrap = true }, -- Wrap notifications
        },
    },

    image = {
        enabled = true,
    },

    picker = {
        enabled = true,
        main = {
            file = false,
        },
    },

    lazygit = {
        enabled = true,
    },

    terminal = {
        enabled = true,
        win = {
            on_buf = function(self)
                -- NOTE: `on_buf` called before `on_win`
                target_term_id = vim.b[self.buf].snacks_terminal.id
            end,
            on_win = function(self)
                -- INFO: assign event for TermClose
                self:on("TermClose", function()
                    -- HACK: manually detele term buffer before destroy win
                    if vim.api.nvim_buf_is_loaded(self.buf) then
                        vim.api.nvim_buf_delete(self.buf, { force = true })
                    end
                    self:destroy()
                    vim.cmd.checktime()
                end, { buf = true })
            end,
        },
    },
}

M.keys = {
    -- Top Pickers
    {
        "<leader>ff",
        function()
            Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
    },
    {
        "<leader>fF",
        function()
            Snacks.picker.files()
        end,
        desc = "Simple Find Files",
    },
    {
        "<leader>fb",
        function()
            Snacks.picker.buffers()
        end,
        desc = "Buffers",
    },
    {
        "<leader>fg",
        function()
            Snacks.picker.grep()
        end,
        desc = "Grep",
    },
    {
        "<leader>fH",
        function()
            Snacks.picker.command_history()
        end,
        desc = "Command History",
    },
    {
        "<leader>fN",
        function()
            Snacks.picker.notifications()
        end,
        desc = "Notification History",
    },
    {
        "<leader>fy",
        function()
            Snacks.picker.cliphist()
        end,
        desc = "Clipboard History",
    },
    -- {
    --     "<leader>e",
    --     function()
    --         Snacks.explorer()
    --     end,
    --     desc = "File Explorer",
    -- },
    -- find
    {
        "<leader>bf",
        function()
            Snacks.picker.buffers()
        end,
        desc = "Buffers",
    },
    {
        "<leader>fn",
        function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
    },
    -- {
    --     "<leader>ff",
    --     function()
    --         Snacks.picker.files()
    --     end,
    --     desc = "Find Files",
    -- },
    -- {
    --     "<leader>fp",
    --     function()
    --         Snacks.picker.projects()
    --     end,
    --     desc = "Projects",
    -- },
    {
        "<leader>fr",
        function()
            Snacks.picker.resume()
        end,
        desc = "Resume",
    },
    {
        "<leader>fR",
        function()
            Snacks.picker.recent()
        end,
        desc = "Recent",
    },
    -- git
    {
        "<leader>gg",
        function()
            Snacks.lazygit()
        end,
        desc = "Open lazygit",
    },
    {
        "<leader>gf",
        function()
            Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
    },
    {
        "<leader>gb",
        function()
            Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
    },
    {
        "<leader>gl",
        function()
            Snacks.picker.git_log()
        end,
        desc = "Git Log",
    },
    {
        "<leader>gL",
        function()
            Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
    },
    {
        "<leader>gs",
        function()
            Snacks.picker.git_status()
        end,
        desc = "Git Status",
    },
    {
        "<leader>gS",
        function()
            Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
    },
    -- {
    --     "<leader>gdh",
    --     function()
    --         Snacks.picker.git_diff()
    --     end,
    --     desc = "Git Diff (Hunks)",
    -- },
    {
        "<leader>gF",
        function()
            Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
    },
    -- Grep
    {
        "<leader>fsb",
        function()
            Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
    },
    {
        "<leader>fsB",
        function()
            Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
    },
    {
        "<leader>fsg",
        function()
            Snacks.picker.grep()
        end,
        desc = "Grep",
    },
    {
        "<leader>fsw",
        function()
            Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
    },
    -- search
    {
        '<leader>fs"',
        function()
            Snacks.picker.registers()
        end,
        desc = "Registers",
    },
    {
        "<leader>fs/",
        function()
            Snacks.picker.search_history()
        end,
        desc = "Search History",
    },
    {
        "<leader>fsa",
        function()
            Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
    },
    {
        "<leader>fsc",
        function()
            Snacks.picker.command_history()
        end,
        desc = "Command History",
    },
    {
        "<leader>fsC",
        function()
            Snacks.picker.commands()
        end,
        desc = "Commands",
    },
    {
        "<leader>fsd",
        function()
            Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
    },
    {
        "<leader>fsD",
        function()
            Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
    },
    {
        "<leader>fsh",
        function()
            Snacks.picker.help()
        end,
        desc = "Help Pages",
    },
    {
        "<leader>fsH",
        function()
            Snacks.picker.highlights()
        end,
        desc = "Highlights",
    },
    {
        "<leader>fsi",
        function()
            Snacks.picker.icons()
        end,
        desc = "Icons",
    },
    {
        "<leader>fsj",
        function()
            Snacks.picker.jumps()
        end,
        desc = "Jumps",
    },
    {
        "<leader>fsk",
        function()
            Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
    },
    {
        "<leader>fsl",
        function()
            Snacks.picker.loclist()
        end,
        desc = "Location List",
    },
    {
        "<leader>fsm",
        function()
            Snacks.picker.marks()
        end,
        desc = "Marks",
    },
    {
        "<leader>fsM",
        function()
            Snacks.picker.man()
        end,
        desc = "Man Pages",
    },
    {
        "<leader>fsp",
        function()
            Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
    },
    {
        "<leader>fsP",
        function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("data") })
        end,
        desc = "Search for Plugin Files",
    },
    {
        "<leader>fsq",
        function()
            Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
    },
    {
        "<leader>fsR",
        function()
            Snacks.picker.resume()
        end,
        desc = "Resume",
    },
    {
        "<leader>fsu",
        function()
            Snacks.picker.undo()
        end,
        desc = "Undo History",
    },
    {
        "<leader>fuC",
        function()
            Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
    },
    -- LSP
    -- {
    --     "gd",
    --     function()
    --         Snacks.picker.lsp_definitions()
    --     end,
    --     desc = "Goto Definition",
    -- },
    -- {
    --     "gD",
    --     function()
    --         Snacks.picker.lsp_declarations()
    --     end,
    --     desc = "Goto Declaration",
    -- },
    -- {
    --     "gr",
    --     function()
    --         Snacks.picker.lsp_references()
    --     end,
    --     nowait = true,
    --     desc = "References",
    -- },
    -- {
    --     "gI",
    --     function()
    --         Snacks.picker.lsp_implementations()
    --     end,
    --     desc = "Goto Implementation",
    -- },
    -- {
    --     "gy",
    --     function()
    --         Snacks.picker.lsp_type_definitions()
    --     end,
    --     desc = "Goto T[y]pe Definition",
    -- },
    -- {
    --     "<leader>ss",
    --     function()
    --         Snacks.picker.lsp_symbols()
    --     end,
    --     desc = "LSP Symbols",
    -- },
    -- {
    --     "<leader>sS",
    --     function()
    --         Snacks.picker.lsp_workspace_symbols()
    --     end,
    --     desc = "LSP Workspace Symbols",
    -- },

    {
        "<leader>.",
        function()
            Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
    },
    {
        "<leader>S",
        function()
            Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
    },
    -- {
    --     "<leader>uh",
    --     function()
    --         Snacks.notifier.show_history()
    --     end,
    --     desc = "Notification History",
    -- },
    -- {
    --     "<leader>un",
    --     function()
    --         Snacks.notifier.hide()
    --     end,
    --     desc = "Dismiss All Notifications",
    -- },
    {
        "<leader>bd",
        function()
            Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
    },
    -- {
    --     "<leader>cR",
    --     function()
    --         Snacks.rename.rename_file()
    --     end,
    --     desc = "Rename File",
    -- },
    {
        "]]",
        function()
            Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
    },
    {
        "[[",
        function()
            Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
    },
    {
        "<leader>uN",
        desc = "Neovim News",
        function()
            ---@diagnostic disable-next-line: missing-fields
            Snacks.win({
                file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                width = 0.6,
                height = 0.6,
                wo = {
                    spell = false,
                    wrap = false,
                    signcolumn = "yes",
                    statuscolumn = " ",
                    conceallevel = 3,
                },
            })
        end,
    },
    {
        "<c-\\>",
        function()
            -- INFO: only mapped toggle key for no cmd terminal
            local terminal_toggle_opts = {
                win = {
                    keys = {
                        ["<c-\\>"] = { "toggle", mode = "t" },
                    },
                },
            }

            -- NOTE: check target_term_id exist in terminal list
            local user_input = vim.v.count ~= 0
            local check_term_id = user_input and vim.v.count1 or target_term_id
            local terminals = Snacks.terminal.list()
            local matched = false
            local last_checked_id = nil

            for _, terminal in ipairs(terminals) do
                local term_id = vim.b[terminal.buf].snacks_terminal.id
                if term_id then
                    if term_id == check_term_id then
                        vim.api.nvim_feedkeys(tostring(check_term_id), "nx", false)
                        matched = true
                        break
                    end
                    if not last_checked_id or (last_checked_id < check_term_id and term_id < check_term_id) then
                        last_checked_id = term_id
                    end
                end
            end

            -- INFO: if not match any and has valid term then use the prev id before target id in list
            if last_checked_id and not matched and not user_input then
                vim.api.nvim_feedkeys(tostring(last_checked_id), "nx", false)
            end

            Snacks.terminal.toggle(nil, terminal_toggle_opts)
        end,
        desc = "Toggle Terminal",
    },
}

function M.init()
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
                Snacks.debug.inspect(...)
            end
            _G.bt = function()
                Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>Os")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>Ow")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>OL")
            Snacks.toggle.diagnostics():map("<leader>Od")
            Snacks.toggle.line_number():map("<leader>Ol")
            Snacks.toggle
                .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                :map("<leader>Oc")
            Snacks.toggle.treesitter():map("<leader>OT")
            Snacks.toggle
                .option("background", { off = "light", on = "dark", name = "Dark Background" })
                :map("<leader>Ob")
            Snacks.toggle.inlay_hints():map("<leader>Oh")
        end,
    })
end

return M
