local function create_augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

local autosave = create_augroup("autosave")
local autoread = create_augroup("autoread")
local cursorline = create_augroup("cursorline")
local line_return = create_augroup("line_return")
local format_options = create_augroup("format_options")
-- local open_diagnostic = create_augroup("open_diagnostic")
local glsl = create_augroup("glsl")
local unception = create_augroup("unception")
local highlight_yank = create_augroup("highlight_yank")
local resize_splits = create_augroup("resize_splits")
local close_with_q = create_augroup("close_with_q")
local wrap_spell = create_augroup("wrap_spell")
local auto_create_dir = create_augroup("auto_create_dir")

local autocommands = {
    -- highlight on yank
    {
        events = { "TextYankPost" },
        group = highlight_yank,
        callback = function()
            vim.highlight.on_yank()
        end,
    },
    -- resize splits if window got resized
    {
        events = { "VimResized" },
        group = resize_splits,
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
        end,
    },
    -- close some filetypes with <q>
    {
        events = { "FileType" },
        group = close_with_q,
        pattern = {
            "PlenaryTestPopup",
            "help",
            "lspinfo",
            "man",
            "notify",
            "qf",
            "query",
            "spectre_panel",
            "startuptime",
            "tsplayground",
            "neotest-output",
            "checkhealth",
            "neotest-summary",
            "neotest-output-panel",
            "Jaq",
            "oil",
            "DressingSelect",
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end,
    },
    -- wrap and check for spell in text filetypes
    {
        events = { "FileType" },
        group = wrap_spell,
        pattern = { "gitcommit", "markdown" },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end,
    },
    -- Auto create dir when saving a file, in case some intermediate directory does not exist
    {
        events = { "BufWritePre" },
        group = auto_create_dir,
        callback = function(event)
            if event.match:match("^%w%w+://") then
                return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end,
    },

    -- Autosave only when there is something to save
    {
        events = { "FocusLost", "BufLeave" },
        group = autosave,
        pattern = "*",
        command = [[lua require("config.functions").save_if_unsaved()]],
    },
    -- Trigger `autoread` when files changes on disk
    {
        events = { "FocusGained", "BufEnter", "CursorHoldI" },
        group = autoread,
        pattern = "*",
        command = [[if mode() != 'c' | checktime | endif]],
    },
    {
        events = { "FileChangedShellPost" },

        group = autoread,
        pattern = { "*" },
        command = [[lua require("notify")("File changed on disk. Buffer reloaded.", "warn")]],
    },
    -- Cursorline
    {
        events = { "WinLeave" },

        group = cursorline,
        pattern = { "*" },
        command = [[set nocursorline]],
    },
    {
        events = { "WinEnter" },
        group = cursorline,
        pattern = { "*" },
        command = [[set cursorline]],
    },
    -- Make sure Vim returns to the same line when you reopen a file
    {
        events = { "BufReadPost" },

        group = line_return,
        pattern = { "*" },
        callback = function(event)
            local exclude = { "gitcommit" }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
                return
            end
            vim.b[buf].last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    },
    -- {
    --     events = { "BufReadPost" },

    --     group = line_return,
    --     pattern = { "*" },
    --     command = [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]],
    -- },
    {
        events = { "BufRead", "BufEnter" },
        group = format_options,
        pattern = { "*" },
        command = [[set formatoptions-=cro]],
    },
    -- {
    --     events = { "CursorHold" },
    --     group = open_diagnostic,
    --     pattern = { "*" },
    --     command = [[lua require("config.functions").open_diagnostic()]],
    -- }
    -- Set glsl filetype
    {
        events = { "BufNewFile", "BufRead" },
        group = glsl,
        pattern = "*.vert,*.tesc,*.tese,*.glsl,*.geom,*.frag,*.comp,*.rgen,*.rmiss,*.rchit,*.rahit,*.rint,*.rcall",
        command = [[set filetype=glsl]],
    },
    {
        events = { "User" },
        group = unception,
        pattern = "UnceptionEditRequestReceived",
        -- command = [[<cmd>close<cr>]],
        callback = function()
            local lazyterm = function()
                require("config.terminal")(nil, { cwd = require("config.functions").root.get() })
            end
            lazyterm()
        end,
    },
}

local function create_autocommands(commands)
    for _, cmd in pairs(commands) do
        vim.api.nvim_create_autocmd(cmd.events, {
            group = cmd.group,
            pattern = cmd.pattern,
            command = cmd.command,
            callback = cmd.callback,
        })
    end
end

create_autocommands(autocommands)
