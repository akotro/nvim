local M = {}

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.keys = {
    {
        "<leader>e",
        function()
            require("oil").open_float()
        end,
        desc = "Explorer",
    },
}

M.opts = {
    columns = {
        "icon",
        "size",
        "mtime",
        -- "permissions",
    },
    default_file_explorer = true,
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["<C-s>"] = "actions.select_vsplit",
        -- ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
    view_options = {
        show_hidden = true,
    },
    float = {
        padding = 4,
    },
}

return M
