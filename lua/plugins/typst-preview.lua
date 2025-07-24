local M = {}

M.build = function()
    require("typst-preview").update()
end

return M
