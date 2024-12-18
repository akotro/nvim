local utils = require("config.functions")

vim.g.mapleader = ","
-- vim.g.maplocalleader = "\\"

local opt = vim.opt

if utils.is_win() then
    -- Enable powershell as your default shell
    vim.cmd([[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
		set shellquote= shellxquote=
    ]])

    -- vim.cmd([[
    --     let &shell = 'nu'
    --     let &shellcmdflag = '-c'
    --     let &shellquote = ""
    --     let &shellxquote = ""
    --  ]])
    -- opt.shell = "wsl.exe"
    -- opt.shellcmdflag = "-e"
end

opt.clipboard = "unnamedplus"
if utils.is_wsl() then
    -- Set a compatible clipboard manager
    vim.g.clipboard = {
        copy = {
            ["+"] = "/mnt/c/Users/koa/.local/bin/win32yank.exe -i --crlf",
            ["*"] = "/mnt/c/Users/koa/.local/bin/win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "/mnt/c/Users/koa/.local/bin/win32yank.exe -o --lf",
            ["*"] = "/mnt/c/Users/koa/.local/bin/win32yank.exe -o --lf",
        },
    }
end

if vim.g.neovide then
    vim.o.guifont = "FiraCode NF:h10"
    vim.cmd([[
        function! ZoomIn()
            let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
            let l:gf_size_whole = l:gf_size_whole + 1
            let l:new_font_size = ':h'.l:gf_size_whole
            let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
        endfunction

        function! ZoomOut()
            let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
            let l:gf_size_whole = l:gf_size_whole - 1
            let l:new_font_size = ':h'.l:gf_size_whole
            let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
        endfunction

        command! ZoomIn call ZoomIn()
        command! ZoomOut call ZoomOut()

    ]])
    vim.api.nvim_set_keymap("n", "<c-+>", ":ZoomIn<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<c-=>", ":ZoomIn<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<c-->", ":ZoomOut<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
        "n",
        "<c-0>",
        [[<cmd>lua vim.o.guifont = "FiraCode NF:h10"<cr>]],
        { noremap = true, silent = true }
    )

    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_floating_shadow = false
    opt.linespace = -1
    vim.g.neovide_hide_mouse_when_typing = true
    vim.cmd([[inoremap <c-s-v> <c-r>+]])
    vim.cmd([[cnoremap <c-s-v> <c-r>+]])
    vim.g.neovide_underline_stroke_scale = 0.5
end

opt.title = true
-- opt.autowrite = true           -- Enable auto write
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.colorcolumn = "110"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
-- Visualise tabs,trailing spaces etc.
opt.list = true
-- opt.listchars = { tab = '  ', trail = '·', extends = '≺', precedes = '❮ ' } -- eol=¬
opt.listchars = [[tab:  ,trail:·,extends:≺,precedes:❮]] -- eol:¬
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = false, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.spelllang = { "en" }
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.splitbelow = true -- Put new windows below current
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.cinoptions = "l1,(0,w1,W4,U1,m1,j1"
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
-- Wrap long lines
-- if utils.is_win() then
--     opt.wrap = true -- TODO: Bad for performance??
-- else
opt.wrap = false
-- end
opt.showbreak = [[↪ ]]
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    -- fold = "⸱",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}

if vim.fn.has("nvim-0.10") == 1 then
    opt.smoothscroll = true
end

-- Folding
-- opt.foldlevel = 99

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- NOTE: Needed for rust cargo build
vim.cmd([[
    set errorformat=
        \%-G,
        \%-Gerror:\ aborting\ %.%#,
        \%-Gerror:\ Could\ not\ compile\ %.%#,
        \%Eerror:\ %m,
        \%Eerror[E%n]:\ %m,
        \%Wwarning:\ %m,
        \%Inote:\ %m,
        \%C\ %#-->\ %f:%l:%c,
        \%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z
]])
