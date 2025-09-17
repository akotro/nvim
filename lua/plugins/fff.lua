local M = {}

-- M.build = function()
--     require("fff.download").download_or_build_binary()
-- end
M.build = "nix run .#release --accept-flake-config"

M.opts = {
    prompt = require("config.ui").icons.ui.FindFile .. " ",
    preview = {
        show_file_info = true,
    },
}

M.keys = {
    {
        "<leader>ff",
        function()
            require("fff").find_files()
        end,
        desc = "Open file picker",
    },
}

return M
