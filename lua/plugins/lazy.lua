return {
    -- the colorscheme should be available when starting Neovim
    {
        "rebelot/kanagawa.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            local status, kanagawa = pcall(require, "kanagawa")
            if not status then
                vim.notify("Kanagawa not found", vim.log.levels.ERROR)
            else
                kanagawa.setup({
                    colors = {
                        theme = { all = { ui = { bg_gutter = "none" } } },
                    },
                })
                vim.cmd([[colorscheme kanagawa]])
            end
        end,
    },
}
