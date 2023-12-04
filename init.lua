require("config.options")
require("config.keymaps")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- bootstrap lazy.nvim
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local plugins = require("plugins")
require("lazy").setup(plugins, {
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
