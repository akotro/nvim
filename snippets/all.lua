local ls = require("luasnip")
local s = ls.snippet
-- local i = ls.insert_node
local t = ls.text_node

local function dateYMD()
    return os.date("%Y-%m-%d")
end

return {
    s("dateYMD", {
        t(dateYMD()),
    }),
}
