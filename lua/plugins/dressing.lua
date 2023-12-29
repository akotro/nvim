local M = {}

function M.init()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
    end
end

M.opts = {
    select = {
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
        get_config = function(opts)
            if opts.kind == "Jaq" then
                return {
                    backend = "builtin",
                }
            end
        end,
    },
}

return M
