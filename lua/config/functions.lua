-----------------------------------------------------------
-- Global Functions ---------------------------------------
-----------------------------------------------------------

-----------------------------------------------------------
-- Inspect lua code with notify
-----------------------------------------------------------
_G.d = function(...)
    local info = debug.getinfo(2, "S")
    local source = info.source:sub(2)
    source = vim.loop.fs_realpath(source) or source
    source = vim.fn.fnamemodify(source, ":~:.") .. ":" .. info.linedefined
    local what = { ... }
    if vim.tbl_islist(what) and vim.tbl_count(what) <= 1 then
        what = what[1]
    end
    local msg = vim.inspect(vim.deepcopy(what))
    require("notify").notify(msg, vim.log.levels.INFO, {
        title = "Debug: " .. source,
        on_open = function(win)
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = ""
            vim.wo[win].spell = false
            local buf = vim.api.nvim_win_get_buf(win)
            vim.treesitter.start(buf, "lua")
        end,
    })
end

-----------------------------------------------------------
-- Local Functions ---------------------------------------
-----------------------------------------------------------

local M = {}

-----------------------------------------------------------
-- Remove augroup
-- @param name: name of augroup to remove
-----------------------------------------------------------
function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

-----------------------------------------------------------
-- Get length of current word
-----------------------------------------------------------
function M.get_word_length()
    local word = vim.fn.expand("<cword>")
    return #word
end

-----------------------------------------------------------
-- Toggles given option
-- @param option: the vim.opt option to toggle
-----------------------------------------------------------
function M.toggle_option(option)
    local value = not vim.api.nvim_get_option_value(option, {})
    vim.opt[option] = value
    require("notify")(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
    local value = vim.api.nvim_get_option_value("showtabline", {})

    if value == 2 then
        value = 0
    else
        value = 2
    end

    vim.opt.showtabline = value

    require("notify")("showtabline" .. " set to " .. tostring(value))
end

-----------------------------------------------------------
-- Toggles diagnostics
-----------------------------------------------------------
local diagnostics_active = true
function M.toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

-----------------------------------------------------------
-- Opens diagnostic in line under the cursor
-----------------------------------------------------------
function M.open_diagnostic()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
            return
        end
    end
    vim.diagnostic.open_float({ focusable = false })
end

function M.isempty(s)
    return s == nil or s == ""
end

function M.get_buf_option(opt)
    local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
    if not status_ok then
        return nil
    else
        return buf_option
    end
end

-----------------------------------------------------------
-- Prompts user if buffer modified before quitting
-----------------------------------------------------------
function M.smart_quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if modified then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
            if input == "y" then
                vim.cmd("q!")
            end
        end)
    else
        vim.cmd("q!")
    end
end

-----------------------------------------------------------
-- Checks if running under Windows.
-----------------------------------------------------------
function M.is_win()
    if jit.os == "Windows" then
        return true
    else
        return false
    end
end

-----------------------------------------------------------
-- Checks if running under Windows.
-----------------------------------------------------------
function M.is_wsl()
    if os.getenv("WSL_DISTRO_NAME") ~= nil then
        return true
    else
        return false
    end
end

-----------------------------------------------------------
-- Checks if running under Linux.
-----------------------------------------------------------
function M.is_linux()
    if jit.os == "Linux" then
        return true
    else
        return false
    end
end

-----------------------------------------------------------
-- Contatenates given paths with correct separator.
-- @param: var args of string paths to joon.
-----------------------------------------------------------
function M.join_paths(...)
    local path_sep = M.is_win() and "\\" or "/"
    local result = table.concat({ ... }, path_sep)
    return result
end

-----------------------------------------------------------
-- Strips trailing whitespaces.
-----------------------------------------------------------
function M.strip_trailing_whitespace()
    if vim.bo.modifiable then
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.histdel("/", -1)
        vim.fn.cursor({ line, col })
    end
end

-----------------------------------------------------------
-- Vimscript has() function
-- @param str: the string to evaluate
-----------------------------------------------------------
function M.has(str)
    return vim.fn.has(str) == 1
end

-----------------------------------------------------------
-- Vimscript executable() function
-- @param str: the string to evaluate
-----------------------------------------------------------
function M.executable(str)
    return vim.fn.executable(str) == 1
end

-----------------------------------------------------------
-- Vimscript exists() function
-- @param str: the string to evaluate
-----------------------------------------------------------
function M.exists(str)
    return vim.fn.exists(str) == 1
end

-----------------------------------------------------------
-- Create keymapping
-- @param mode: string or table of modes
-- @param lhs: left hand side of mapping
-- @param rhs: right hand side of mapping
-- @param opts: table of mapping options eg. {silent = true}
-----------------------------------------------------------
function M.map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

-----------------------------------------------------------
-- Create autocommand
-- @param autocmds: table of autocommands
--     eg. { {'events', 'pattern', 'command', 'argument'} }
-- @param name: name of augroup
-----------------------------------------------------------
function M.create_augroup(autocmds, name)
    local cmd = vim.cmd
    cmd("augroup " .. name)
    cmd("autocmd!")
    for _, autocmd in ipairs(autocmds) do
        cmd("autocmd " .. table.concat(autocmd, " "))
    end
    cmd("augroup END")
end

function M.set_of(list)
    local set = {}
    for i = 1, #list do
        set[list[i]] = true
    end
    return set
end

-----------------------------------------------------------
-- Check if var is in array
-----------------------------------------------------------
function M.not_in(var, arr)
    if M.set_of(arr)[var] == nil then
        return true
    end
end

function M.match_in_table(pattern, arr)
    for _, str in ipairs(arr) do
        if string.match(str, pattern) then
            print(pattern .. "matched with: " .. str)
            return true
        end
    end
end

-----------------------------------------------------------
-- Save buffer if modified
-----------------------------------------------------------
function M.save_if_unsaved()
    local ignore_filetypes = {
        "TelescopePrompt",
        "CommandTPrompt",
        "Trouble",
        "NvimTree",
        "dap-repl",
        "dapui_watches",
        "dapui_hover",
    }
    local current_buf = vim.api.nvim_get_current_buf()
    local filetype = vim.fn.getbufvar(current_buf, "&filetype")
    local modified = vim.api.nvim_buf_get_option(current_buf, "modified")
    local modifiable = vim.fn.getbufvar(current_buf, "&modifiable")
    local dont_ignore_type = M.not_in(filetype, ignore_filetypes)

    local buf_name = vim.api.nvim_buf_get_name(current_buf)
    local is_unnamed_buffer = (buf_name == nil or buf_name == "")

    if modifiable == 1 and modified and dont_ignore_type and not is_unnamed_buffer then
        -- vim.cmd("silent! w")
        vim.cmd("silent w")
        require("notify")("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
        -- print("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
    end
end

-----------------------------------------------------------
-- Returns an iterator (for i in range())
-- range(start)             iterator from 1 to a (step = 1)
-- range(start, stop)       iterator from a to b (step = 1)
-- range(start, stop, step) iterator from a to b, by step.
-----------------------------------------------------------
function M.range(i, to, inc)
    if i == nil then
        return
    end -- no arg -> return
    if not to then
        to = i
        i = to == 0 and 0 or (to > 0 and 1 or -1)
    end
    -- we don't have to do the to == 0 check
    -- 0 -> 0 with any inc would never iterate
    inc = inc or (i < to and 1 or -1)
    -- step back (once) before we start
    i = i - inc
    return function()
        if i == to then
            return nil
        end
        i = i + inc
        return i, i
    end
end

-----------------------------------------------------------
-- Focus floating window
-----------------------------------------------------------
function M.focus_first_float()
    for w in M.range(1, vim.fn.winnr("$")) do
        local c = vim.api.nvim_win_get_config(vim.fn.win_getid(w))
        if c.focusable and c.relative ~= "" then
            -- print("found " .. c)
            vim.cmd("exe " .. w .. " 'wincmd w'")
        end
    end
end

return M
