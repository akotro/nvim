require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local plugins = require("plugins")
-- local concurrency_level = require("config.functions").matches_hostname("koa-PC") and 1 or nil
require("lazy").setup(plugins, {
    dev = {
        path = "~/dev",
    },
    -- concurrency = concurrency_level,
    git = {
        timeout = 420,
    },
    checker = { enabled = true, notify = false }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zip",
                "zipPlugin",
                "getscript",
                "getscriptplugin",
                "vimball",
                "vimballPlugin",
                "2html_plugin",
                "logiPat",
                "rrhelper",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "spellfile",
                "matchit",
            },
        },
    },
})
