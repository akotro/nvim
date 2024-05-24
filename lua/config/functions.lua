-----------------------------------------------------------
-- Global Functions ---------------------------------------
-----------------------------------------------------------

-----------------------------------------------------------
-- Inspect lua code with notify
-----------------------------------------------------------
_G.p = function(...)
    local info = debug.getinfo(2, "S")
    local source = info.source:sub(2)
    source = vim.loop.fs_realpath(source) or source
    source = vim.fn.fnamemodify(source, ":~:.") .. ":" .. info.linedefined
    local what = { ... }
    if vim.islist(what) and vim.tbl_count(what) <= 1 then
        what = what[1]
    end
    local msg = vim.inspect(vim.deepcopy(what))
    vim.notify(msg, vim.log.levels.INFO, {
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

-- Credit to https://github.com/roobert/search-replace.nvim
M.search = {}

M.search.options = {
    default_replace_single_buffer_options = "gcI",
    default_replace_no_ask_single_buffer_options = "gI",
    default_replace_multi_buffer_options = "egcI",
}

---@param global? boolean
---@param no_ask? boolean
---@param normal? boolean
M.search.search_replace = function(pattern, global, no_ask, normal)
    global = global or false
    normal = normal or false
    no_ask = no_ask or false

    local shift = 0

    if string.len(pattern) == 0 then
        shift = 2
    else
        shift = 1
    end

    local prefix = ".,$"
    if global then
        prefix = "%"
    end

    local default_options = M.search.options.default_replace_single_buffer_options
    if no_ask then
        default_options = M.search.options.default_replace_no_ask_single_buffer_options
    end

    local left_keypresses = string.rep("\\<Left>", string.len(default_options) + shift)
    if normal then
        left_keypresses = string.rep("\\<Left>", string.len(default_options) + 1)
    end

    if normal == false then
        vim.cmd(
            ':call feedkeys(":'
                .. prefix
                .. "s@"
                .. M.search.util.double_escape(pattern)
                .. "@@"
                .. default_options
                .. left_keypresses
                .. '")'
        )
    else
        vim.cmd(':call feedkeys(":' .. prefix .. "s@" .. "@" .. default_options .. left_keypresses .. '")')
    end
end

---@param global boolean
---@param no_ask boolean
M.search.open = function(global, no_ask)
    M.search.search_replace("", global, no_ask, true)
end

---@param global boolean
---@param no_ask boolean
M.search.cword = function(global, no_ask)
    M.search.search_replace(vim.fn.expand("<cword>"), global, no_ask)
end

---@param global boolean
---@param no_ask boolean
M.search.cWORD = function(global, no_ask)
    M.search.search_replace(vim.fn.expand("<cWORD>"), global, no_ask)
end

---@param global boolean
---@param no_ask boolean
M.search.cexpr = function(global, no_ask)
    M.search.search_replace(vim.fn.expand("<cexpr>"), global, no_ask)
end

---@param global boolean
---@param no_ask boolean
M.search.cfile = function(global, no_ask)
    M.search.search_replace(vim.fn.expand("<cfile>"), global, no_ask)
end

---@param no_ask? boolean
---@param normal? boolean
M.search.search_within = function(pattern, no_ask, normal)
    normal = normal or false
    no_ask = no_ask or false

    local shift = 0

    if string.len(pattern) == 0 then
        shift = 2
    else
        shift = 1
    end

    local default_options = M.search.options.default_replace_single_buffer_options
    if no_ask then
        default_options = M.search.options.default_replace_no_ask_single_buffer_options
    end

    local left_keypresses = string.rep("\\<Left>", string.len(default_options) + shift)
    if normal then
        left_keypresses = string.rep("\\<Left>", string.len(default_options) + 1)
    end

    if normal == false then
        vim.cmd(
            ':call feedkeys(":s@'
                .. M.search.util.double_escape(pattern)
                .. "@@"
                .. default_options
                .. left_keypresses
                .. '")'
        )
    else
        vim.cmd(':call feedkeys(":s@' .. "@" .. default_options .. left_keypresses .. '")')
    end
end

---@param no_ask boolean
M.search.within = function(no_ask)
    M.search.search_within("", no_ask, true)
end

---@param no_ask boolean
M.search.within_cword = function(no_ask)
    M.search.search_within(vim.fn.expand("<cword>"), no_ask)
end

---@param no_ask boolean
M.search.within_cWORD = function(no_ask)
    M.search.search_within(vim.fn.expand("<cWORD>"), no_ask)
end

---@param no_ask boolean
M.search.within_cexpr = function(no_ask)
    M.search.search_within(vim.fn.expand("<cexpr>"), no_ask)
end

---@param no_ask boolean
M.search.within_cfile = function(no_ask)
    M.search.search_within(vim.fn.expand("<cfile>"), no_ask)
end

M.search.util = {}

-- double escaping is required due to interpretation by feedkeys and then search/replace
M.search.util.double_escape = function(str)
    -- FIXME: how to handle <>'s, etc.
    local escape_characters = '"\\/.*$^~[]'
    return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

-- taken from: https://github.com/ibhagwan/nvim-lua/blob/f772c7b41ac4da6208d8ae233e1c471397833d64/lua/utils.lua#L96
function M.search.util.get_visual_selection(nl_literal)
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "" then
        -- if we are in visual mode use the live position
        _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
        _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))

        if mode == "V" then
            -- visual line doesn't provide columns
            cscol, cecol = 0, 999
        end

        -- exit visual mode
        --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    else
        -- otherwise, use the last known visual position
        _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
        _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    end

    -- swap vars if needed
    if cerow < csrow then
        csrow, cerow = cerow, csrow
    end

    if cecol < cscol then
        cscol, cecol = cecol, cscol
    end

    local lines = vim.fn.getline(csrow, cerow)

    -- local n = cerow-csrow+1
    local n = #lines

    if n <= 0 then
        return ""
    end

    -- we don't support multi-line selections
    if n > 1 then
        return nil
    end

    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)

    return table.concat(lines, nl_literal and "\\n" or "\n")
end

M.plugin = {}

---@param plugin string
function M.plugin.has(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param plugin string
function M.plugin.loaded(plugin)
    local lazy = require("lazy.core.config")
    return lazy.spec.plugins[plugin] ~= nil and lazy.spec.plugins[plugin]._.loaded ~= nil
end

---@param name string
function M.plugin.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

M.lsp = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.lsp.get_clients(opts)
    local ret = {} ---@type lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_clients(opts)
        if opts and opts.method then
            ---@param client lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client, buffer)
function M.lsp.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param from string
---@param to string
function M.lsp.on_rename(from, to)
    local clients = M.lsp.get_clients()
    for _, client in ipairs(clients) do
        if client.supports_method("workspace/willRenameFiles") then
            ---@diagnostic disable-next-line: invisible
            local resp = client.request_sync("workspace/willRenameFiles", {
                files = {
                    {
                        oldUri = vim.uri_from_fname(from),
                        newUri = vim.uri_from_fname(to),
                    },
                },
            }, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end
    end
end

---@return _.lspconfig.options
function M.lsp.get_config(server)
    local configs = require("lspconfig.configs")
    return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.lsp.disable(server, cond)
    local util = require("lspconfig.util")
    local def = M.lsp.get_config(server)
    ---@diagnostic disable-next-line: undefined-field
    def.document_config.on_new_config = util.add_hook_before(
        def.document_config.on_new_config,
        function(config, root_dir)
            if cond(root_dir, config) then
                config.enabled = false
            end
        end
    )
end

---@type table<number, string>
M.cache = {}

M.root = {}

function M.root.bufpath(buf)
    return M.root.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.root.cwd()
    return M.root.realpath(vim.loop.cwd()) or ""
end

function M.root.realpath(path)
    if path == "" or path == nil then
        return nil
    end
    path = vim.loop.fs_realpath(path) or path
    return path
    -- return M.norm(path)
end

M.root.spec = { "lsp", { ".git", "lua" }, "cwd" }

M.root.detectors = {}

function M.root.detectors.cwd()
    return { vim.loop.cwd() }
end

function M.root.detectors.lsp(buf)
    local bufpath = M.root.bufpath(buf)
    if not bufpath then
        return {}
    end
    local roots = {} ---@type string[]
    for _, client in pairs(M.lsp.get_clients({ bufnr = buf })) do
        -- only check workspace folders, since we're not interested in clients
        -- running in single file mode
        local workspace = client.config.workspace_folders
        for _, ws in pairs(workspace or {}) do
            roots[#roots + 1] = vim.uri_to_fname(ws.uri)
        end
    end
    return vim.tbl_filter(function(path)
        path = M.norm(path)
        return path and bufpath:find(path, 1, true) == 1
    end, roots)
end

---@param patterns string[]|string
function M.root.detectors.pattern(buf, patterns)
    patterns = type(patterns) == "string" and { patterns } or patterns
    local path = M.root.bufpath(buf) or vim.loop.cwd()
    local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.root.resolve(spec)
    if M.root.detectors[spec] then
        return M.root.detectors[spec]
    elseif type(spec) == "function" then
        return spec
    end
    return function(buf)
        return M.root.detectors.pattern(buf, spec)
    end
end

function M.root.detect(opts)
    opts = opts or {}
    opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.root.spec
    opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

    local ret = {}
    for _, spec in ipairs(opts.spec) do
        local paths = M.root.resolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == "table" and paths or { paths }
        local roots = {} ---@type string[]
        for _, p in ipairs(paths) do
            local pp = M.root.realpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
                roots[#roots + 1] = pp
            end
        end
        table.sort(roots, function(a, b)
            return #a > #b
        end)
        if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
                break
            end
        end
    end
    return ret
end
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean}
---@return string
function M.root.get(opts)
    local buf = vim.api.nvim_get_current_buf()
    local ret = M.cache[buf]
    if not ret then
        local roots = M.root.detect({ all = false })
        ret = roots[1] and roots[1].paths[1] or vim.loop.cwd()
        M.cache[buf] = ret
    end
    if opts and opts.normalize then
        return ret
    end
    return M.is_win() and ret:gsub("/", "\\") or ret
end

M.window = {}

function M.window.is_portrait_mode()
    local lines = vim.api.nvim_win_get_height(0)
    local columns = vim.api.nvim_win_get_width(0)
    -- d("lines", lines, "columns", columns)

    local ratio = lines / columns

    if ratio >= 0.5 then
        return true
    end
    return false
end

function M.norm(path)
    -- Replace backslashes with forward slashes (common in Windows paths)
    path = path:gsub("\\", "/")

    -- Remove redundant slashes
    path = path:gsub("//+", "/")

    -- Resolve '.' and '..'
    local parts = {}
    for part in path:gmatch("[^/]+") do
        if part == ".." then
            -- Move up a directory; remove last element from 'parts'
            table.remove(parts)
        elseif part ~= "." then
            -- Normal directory name; add it to 'parts'
            table.insert(parts, part)
        end
    end

    return table.concat(parts, "/")
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
    local Config = require("lazy.core.config")
    if Config.plugins[name] and Config.plugins[name]._.loaded then
        fn(name)
    else
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyLoad",
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

---@param fn fun()
function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            fn()
        end,
    })
end

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
    vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
    local value = vim.api.nvim_get_option_value("showtabline", {})

    if value == 2 then
        value = 0
    else
        value = 2
    end

    vim.opt.showtabline = value

    vim.notify("showtabline" .. " set to " .. tostring(value))
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
-- Deletes all [No Name] and empty buffers
-----------------------------------------------------------
function M.delete_empty_buffers()
    vim.api.nvim_exec([[bufdo! if empty(getbufvar(bufnr('%'), '&buftype')) && empty(bufname('%')) | bd | endif]], false)
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
-- Checks the current hostname.
-----------------------------------------------------------
function M.matches_hostname(hostname)
    local current_hostname = io.popen("hostname"):read("*a")
    current_hostname = current_hostname:gsub("%s+", "")

    if vim.islist(hostname) then
        for _, v in ipairs(hostname) do
            if current_hostname == v then
                return true
            end
        end
    else
        return current_hostname == hostname
    end

    return false
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
        vim.notify("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
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
