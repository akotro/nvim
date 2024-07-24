return {
    name = "cargo nextest",
    builder = function()
        return {
            cmd = { "cargo" },
            args = { "nextest", "run" },
        }
    end,
    condition = {
        filetype = { "rust" },
    },
}
