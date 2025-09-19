local M = {}

M.keys = {
    {
        "<leader>e",
        function()
            require("oil").toggle_float(vim.fn.getcwd())
        end,
        desc = "Explorer (cwd)",
    },
    {
        "<leader>E",
        function()
            local oil = require("oil")
            oil.toggle_float(oil.get_current_dir())
        end,
        desc = "Explorer (file dir)",
    },
}

M.opts = {
    columns = {
        "icon",
        "size",
        "mtime",
        "permissions",
    },
    default_file_explorer = true,
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
    },
    watch_for_changes = true,
    use_default_keymaps = false,
    view_options = {
        show_hidden = true,
    },
    float = {
        padding = 4,
    },
}

M.config = function(_, opts)
    require("oil").setup(opts)

    local has_snacks, snacks = pcall(require, "snacks")
    if has_snacks then
        vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
                if event.data.actions.type == "move" then
                    snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
                end
            end,
        })
    end
end

return M
