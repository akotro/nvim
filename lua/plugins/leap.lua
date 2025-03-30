local M = {}

M.dependencies = {
    "tpope/vim-repeat",
}

function M.config(_, opts)
    -- Bidirectional s for Normal and Visual mode:
    -- Trade-off: Compared to using separate keys for the two directions,
    --   you will only get half as many autojumps on average.
    vim.keymap.set({ "n", "x" }, "s", "<Plug>(leap)")
    vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    vim.keymap.set("o", "s", "<Plug>(leap-forward)")
    vim.keymap.set("o", "S", "<Plug>(leap-backward)")
    -- Remote operations
    vim.keymap.set({ "n", "x", "o" }, "gs", function()
        require("leap.remote").action()
    end)

    -- Define equivalence classes for brackets and quotes, in addition to
    -- the default whitespace group:
    require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

    -- Use the traversal keys to repeat the previous motion without
    -- explicitly invoking Leap:
    require("leap.user").set_repeat_keys("<enter>", "<backspace>")
end

return M
