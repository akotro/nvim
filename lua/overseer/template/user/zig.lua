return {
    name = "zig build",
    builder = function()
        return {
            cmd = { "zig" },
            args = { "build" },
            components = { { "on_output_quickfix", open = false }, "default" },
            -- components = { { "on_result_diagnostics_trouble", close = true }, "default" },
        }
    end,
    condition = {
        filetype = { "zig" },
    },
}
