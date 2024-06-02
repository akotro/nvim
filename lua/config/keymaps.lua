local keymap = vim.keymap
local remapOpts = { remap = true, silent = true }
local silentOpts = { silent = true }
local allModes = ""

keymap.set(allModes, ";", ":")

-- cursor movement
keymap.set({ "n", "v" }, "J", "<c-d>")
keymap.set({ "n", "v" }, "K", "<c-u>")
keymap.set({ "n", "v" }, "<s-h>", "^")
keymap.set({ "n", "v" }, "<s-l>", "g_")

-- better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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

-- buffers
-- keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
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

-- newline with enter
keymap.set("n", "<CR>", "o<Esc>", silentOpts)

-- redo
keymap.set("n", "R", "<C-R>")

-- tab to match pairs
keymap.set({ "n", "v" }, "<tab>", "%", silentOpts)
-- folding
keymap.set("n", "<space>", "za", silentOpts)

-- strip trailing whitespace
keymap.set("n", "<f5>", [[<cmd>lua require("config.functions").strip_trailing_whitespace()<cr>]], silentOpts)

--keywordprg
keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- keymap.set({ "i", "n" }, "<leader><space>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
keymap.set(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" }
)

-- floating terminal
-- local lazyterm = function()
--     require("config.terminal")(nil, { cwd = require("config.functions").root.get() })
-- end
-- keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
-- keymap.set("n", "<leader>fT", function()
--     require("config.terminal")()
-- end, { desc = "Terminal (cwd)" })
-- keymap.set("n", "<c-\\>", lazyterm, { desc = "Terminal (root dir)" })
-- keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Searching
-- keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
-- keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
-- keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

local kopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)

-- NOTE: See user/plugins/whichkey for the rest
