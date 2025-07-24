local M = {}

M.keys = {
    {
        "<M-n>",
        function()
            require("bufjump").forward()
        end,
        "Jumplist forward",
    },
    {
        "<M-p>",
        function()
            require("bufjump").backward()
        end,
        "Jumplist backward",
    },
    {
        "<M-i>",
        function()
            require("bufjump").forward_same_buf()
        end,
        "Jumplist forward same buffer",
    },
    {
        "<M-o>",
        function()
            require("bufjump").backward_same_buf()
        end,
        "Jumplist backward same buffer",
    },
}

return M
