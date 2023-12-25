local M = {}

function M.config()
    local utils = require("config.functions")
    local cpp_build = ""
    if utils.is_win() then
        cpp_build = "cmake --preset=msvc && cmake --build ./build --target run"
    else
        cpp_build = "cmake --preset=gcc && cmake --build ./build --target run"
    end

    require("jaq-nvim").setup({
        cmds = {
            default = "quickfix",
            external = {
                c = cpp_build,
                cpp = cpp_build,
                cs = "dotnet build",
                markdown = "glow %",
                python = "python %",
                sh = "sh %",
                -- typescript = "deno run %",
                -- javascript = "node %",
                -- rust = "rustc % && ./$fileBase && rm $fileBase",
                rust = { "cargo build", "cargo build && RUST_BACKTRACE=1 cargo run" },
                -- go = "go run %",
            },
            internal = {
                -- lua = "luafile %",
                -- vim = "source %",
            },
        },
        behavior = {
            default = "quickfix",
            startinsert = false,
            wincmd = false,
            autosave = false,
        },
        ui = {
            float = {
                border = "none",
                height = 0.8,
                width = 0.8,
                x = 0.5,
                y = 0.5,
                border_hl = "FloatBorder",
                float_hl = "Normal",
                blend = 0,
            },
            terminal = {
                position = "bot",
                line_no = false,
                size = 20,
            },
            quickfix = {
                position = "bot",
                size = 20,
            },
        },
    })
end

return M
