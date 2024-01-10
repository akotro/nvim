local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    -- Examples of Greek letter snippets, autotriggered for efficiency
    s({ trig = ";a", snippetType = "autosnippet" }, {
        t("\\alpha"),
    }),
    s({ trig = ";b", snippetType = "autosnippet" }, {
        t("\\beta"),
    }),
    s({ trig = ";g", snippetType = "autosnippet" }, {
        t("\\gamma"),
    }),
    s({ trig = ";e", snippetType = "autosnippet" }, {
        t("\\epsilon"),
    }),
}
