local utils = require("config.functions")
local keymap = vim.keymap
local silentOpts = { silent = true }
local allModes = ""

keymap.set(allModes, ";", ":")
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save", noremap = false }) -- remap=false becomes noremap=true, but for <cmd> it's better to allow remaps
keymap.set("n", "<leader>q", function()
    utils.smart_quit()
end, { desc = "Quit" })
keymap.set("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear Highlight" })

-- redo
keymap.set("n", "R", "<C-R>")

-- tab to match pairs
keymap.set({ "n", "v" }, "<tab>", "%", silentOpts)

-- folding
keymap.set("n", "<space>", "za", silentOpts)

-- cursor movement
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })

keymap.set({ "n", "v" }, "J", "<c-d>")
keymap.set({ "n", "v" }, "K", "<c-u>")
keymap.set({ "n", "v" }, "<s-h>", "^")
keymap.set({ "n", "v" }, "<s-l>", "g_")

-- Splits
keymap.set("n", "<leader>sh", "<cmd>leftabove vsplit<cr>", { desc = "Split Horizontal (Left)" })
keymap.set("n", "<leader>sj", "<cmd>rightbelow split<cr>", { desc = "Split Vertical (Down)" })
keymap.set("n", "<leader>sk", "<cmd>leftabove split<cr>", { desc = "Split Vertical (Up)" })
keymap.set("n", "<leader>sl", "<cmd>rightbelow vsplit<cr>", { desc = "Split Horizontal (Right)" })

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- floating window management
keymap.set("n", "<leader>of", function()
    utils.focus_first_float()
end, { desc = "Focus Floating Window" })
keymap.set("n", "<leader>on", "<cmd>only<cr>", { desc = "Focus This Window (Close others)" })

-- buffers
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- Move Lines
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- strip trailing whitespace
keymap.set("n", "<f5>", function()
    require("config.functions").strip_trailing_whitespace()
end, silentOpts)

-- keywordprg
keymap.set("n", "gK", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Terminal Mappings
keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Searching

-- Replace (Local)
keymap.set("n", "<leader>raW", function()
    utils.search.cWORD(false, false)
end, { desc = "Replace current [W]ORD" })
keymap.set("n", "<leader>rae", function()
    utils.search.cexpr(false, false)
end, { desc = "Replace with [e]xpression" })
keymap.set("n", "<leader>raf", function()
    utils.search.cfile(false, false)
end, { desc = "Replace in current [f]ile" })
keymap.set("n", "<leader>rao", function()
    utils.search.open(false, false)
end, { desc = "Replace with [o]pen dialog" })
keymap.set("n", "<leader>raw", function()
    utils.search.cword(false, false)
end, { desc = "Replace current [w]ord" })

-- Replace (Global)
keymap.set("n", "<leader>rgaW", function()
    utils.search.cWORD(true, false)
end, { desc = "[G]lobal Replace [W]ORD" })
keymap.set("n", "<leader>rgae", function()
    utils.search.cexpr(true, false)
end, { desc = "[G]lobal Replace with [e]xpr" })
keymap.set("n", "<leader>rgaf", function()
    utils.search.cfile(true, false)
end, { desc = "[G]lobal Replace in [f]ile" })
keymap.set("n", "<leader>rgao", function()
    utils.search.open(true, false)
end, { desc = "[G]lobal Replace [o]pen" })
keymap.set("n", "<leader>rgaw", function()
    utils.search.cword(true, false)
end, { desc = "[G]lobal Replace [w]ord" })

-- Replace (Global, No Ask)
keymap.set("n", "<leader>rgnW", function()
    utils.search.cWORD(true, true)
end, { desc = "[G]lobal No-ask Replace [W]ORD" })
keymap.set("n", "<leader>rgne", function()
    utils.search.cexpr(true, true)
end, { desc = "[G]lobal No-ask Replace [e]xpr" })
keymap.set("n", "<leader>rgnf", function()
    utils.search.cfile(true, true)
end, { desc = "[G]lobal No-ask Replace [f]ile" })
keymap.set("n", "<leader>rgno", function()
    utils.search.open(true, true)
end, { desc = "[G]lobal No-ask Replace [o]pen" })
keymap.set("n", "<leader>rgnw", function()
    utils.search.cword(true, true)
end, { desc = "[G]lobal No-ask Replace [w]ord" })

-- Replace (Local, No Ask)
keymap.set("n", "<leader>rnW", function()
    utils.search.cWORD(false, true)
end, { desc = "No-ask Replace [W]ORD" })
keymap.set("n", "<leader>rne", function()
    utils.search.cexpr(false, true)
end, { desc = "No-ask Replace [e]xpr" })
keymap.set("n", "<leader>rnf", function()
    utils.search.cfile(false, true)
end, { desc = "No-ask Replace [f]ile" })
keymap.set("n", "<leader>rno", function()
    utils.search.open(false, true)
end, { desc = "No-ask Replace [o]pen" })
keymap.set("n", "<leader>rnw", function()
    utils.search.cword(false, true)
end, { desc = "No-ask Replace [w]ord" })

-- Replace in Visual Selection
keymap.set("v", "<leader>raW", function()
    utils.search.within_cWORD(false)
end, { desc = "Replace in selection [W]ORD" })
keymap.set("v", "<leader>rae", function()
    utils.search.within_cexpr(false)
end, { desc = "Replace in selection with [e]xpr" })
keymap.set("v", "<leader>raf", function()
    utils.search.within_cfile(false)
end, { desc = "Replace in selection from [f]ile" })
keymap.set("v", "<leader>rao", function()
    utils.search.within(false)
end, { desc = "Replace in selection [o]pen" })
keymap.set("v", "<leader>raw", function()
    utils.search.within_cword(false)
end, { desc = "Replace in selection [w]ord" })

-- Replace in Visual Selection (No Ask)
keymap.set("v", "<leader>rnW", function()
    utils.search.within_cWORD(true)
end, { desc = "No-ask Replace in selection [W]ORD" })
keymap.set("v", "<leader>rne", function()
    utils.search.within_cexpr(true)
end, { desc = "No-ask Replace in selection [e]xpr" })
keymap.set("v", "<leader>rnf", function()
    utils.search.within_cfile(true)
end, { desc = "No-ask Replace in selection [f]ile" })
keymap.set("v", "<leader>rno", function()
    utils.search.within(true)
end, { desc = "No-ask Replace in selection [o]pen" })
keymap.set("v", "<leader>rnw", function()
    utils.search.within_cword(true)
end, { desc = "No-ask Replace in selection [w]ord" })

local kopts = { noremap = true, silent = true }
keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)

-- delete default lsp keybinds
keymap.del("n", "gra")
keymap.del("n", "grn")
keymap.del("n", "grr")
keymap.del("n", "grt")
keymap.del("n", "gri")

-- plugin management (lazy.nvim)
keymap.set("n", "<leader>pi", "<cmd>Lazy install<cr>", { desc = "Install Plugins" })
keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Open Lazy UI" })
keymap.set("n", "<leader>pr", "<cmd>Lazy restore<cr>", { desc = "Restore Plugins" })
keymap.set("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync Plugins" })
keymap.set("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update Plugins" })
keymap.set("n", "<leader>px", "<cmd>Lazy clean<cr>", { desc = "Clean Plugins" })
