local M = {}

M.cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" }

function M.init(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
end

M.dependencies = {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            -- When in diff mode, we want to use the default
            -- vim text objects c & C instead of the treesitter ones.
            local move = require("nvim-treesitter.textobjects.move")
            local configs = require("nvim-treesitter.configs")
            for name, fn in pairs(move) do
                if name:find("goto") == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff then
                            local config = configs.get_module("textobjects.move")[name]
                            for key, query in pairs(config or {}) do
                                if q == query and key:find("[%]%[][cC]") then
                                    vim.cmd("normal! " .. key)
                                    return
                                end
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end,
    },
}

M.keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<bs>", desc = "Decrement selection", mode = "x" },
}

M.opts = {
    highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = { "latex" },
    },
    indent = { enable = true },
    auto_install = true,
    ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "css",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "c_sharp",
        "cpp",
        "rust",
        "ron",
        "sql",
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
    textobjects = {
        move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
    },
}

function M.config(_, opts)
    if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
            if added[lang] then
                return false
            end
            added[lang] = true
            return true
        end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
end

return M
