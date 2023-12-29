local M = {}

function M.config()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
        default = {
            augend.integer.alias.decimal,
            augend.integer.alias.decimal_int,
            augend.integer.alias.hex,
            augend.integer.alias.binary,
            augend.date.alias["%Y/%m/%d"],
            augend.date.alias["%Y-%m-%d"],
            augend.date.alias["%m/%d"],
            augend.date.alias["%H:%M"],
            augend.constant.alias.ja_weekday_full,
            augend.constant.alias.bool,
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha,
            augend.semver.alias.semver,
        },
    })
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), opts)
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), opts)
    vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), opts)
    vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), opts)
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), opts)
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), opts)
end

return M
