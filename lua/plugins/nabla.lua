local M = {}

M.keys = {
    {
        "<leader>np",
        function()
            require("nabla").popup()
        end,
        desc = "Popup latex equation",
    },
}

return M
