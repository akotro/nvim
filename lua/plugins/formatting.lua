local M = {}

M.keys = {
    {
        -- Customize or remove this keymap to your liking
        "<leader>lf",
        function()
            require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
    },
}

-- local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
-- local stylua_path = mason_path .. "stylua"

M.opts = function()
    local slow_format_filetypes = {}
    local ignore_auto_format_filetypes = {
        "cs",
        "xml",
        "h",
        "c",
        "cpp",
    }

    return {
        -- Map of filetype to formatters
        formatters_by_ft = {
            lua = { "stylua" },
            cs = { "csharpier" },
            rust = { "cargo fmt" },
            sh = { "beautysh" },
            -- Conform will run multiple formatters sequentially
            go = { "goimports", "gofmt" },
            -- Use a sub-list to run only the first available formatter
            javascript = { { "prettierd", "prettier" } },
            typescript = { { "prettierd", "prettier" } },
            markdown = { "prettierd" },
            tex = { "prettierd" },
            -- You can use a function here to determine the formatters dynamically
            python = function(bufnr)
                if require("conform").get_formatter_info("ruff_format", bufnr).available then
                    return { "ruff_format" }
                else
                    return { "black" }
                end
            end,
            -- Use the "*" filetype to run formatters on all filetypes.
            -- ["*"] = { "codespell" },
            -- Use the "_" filetype to run formatters on filetypes that don't
            -- have other formatters configured.
            -- ["_"] = { "trim_whitespace" },
        },
        -- If this is set, Conform will run the formatter on save.
        -- It will pass the table to conform.format().
        -- This can also be a function that returns the table.
        -- format_on_save = {
        -- 	-- I recommend these options. See :help conform.format for details.
        -- 	lsp_fallback = true,
        -- 	timeout_ms = 500,
        -- },
        format_on_save = function(bufnr)
            if vim.tbl_contains(ignore_auto_format_filetypes, vim.bo[bufnr].filetype) then
                return
            end
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            -- Disable autoformat for files in a certain path
            -- local bufname = vim.api.nvim_buf_get_name(bufnr)
            -- if bufname:match("/node_modules/") then
            -- 	return
            -- end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
            end
            local function on_format(err)
                if err and err:match("timeout$") then
                    slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
        end,

        format_after_save = function(bufnr)
            if vim.tbl_contains(ignore_auto_format_filetypes, vim.bo[bufnr].filetype) then
                return
            end
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
            end
            return { lsp_fallback = true }
        end,
        -- If this is set, Conform will run the formatter asynchronously after save.
        -- It will pass the table to conform.format().
        -- This can also be a function that returns the table.
        -- format_after_save = {
        --  lsp_fallback = true,
        -- },
        -- Set the log level. Use `:ConformInfo` to see the location of the log file.
        log_level = vim.log.levels.ERROR,
        -- Conform will notify you when a formatter errors
        notify_on_error = true,
        -- Custom formatters and changes to built-in formatters
        formatters = {
            csharpier = {
                args = { "--fast", "--write-stdout" },
            },
            -- beautysh = {
            --     command = "beautysh",
            --     args = { "--indent-size", "2" },
            -- },
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
            -- my_formatter = {
            --  -- This can be a string or a function that returns a string.
            --  -- When defining a new formatter, this is the only field that is *required*
            --  command = "my_cmd",
            --  -- A list of strings, or a function that returns a list of strings
            --  -- Return a single string instead of a list to run the command in a shell
            --  args = { "--stdin-from-filename", "$FILENAME" },
            --  -- If the formatter supports range formatting, create the range arguments here
            --  range_args = function(ctx)
            --      return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
            --  end,
            --  -- Send file contents to stdin, read new contents from stdout (default true)
            --  -- When false, will create a temp file (will appear in "$FILENAME" args). The temp
            --  -- file is assumed to be modified in-place by the format command.
            --  stdin = true,
            --  -- A function that calculates the directory to run the command in
            --  cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
            --  -- When cwd is not found, don't run the formatter (default false)
            --  require_cwd = true,
            --  -- When returns false, the formatter will not be used
            --  condition = function(ctx)
            --      return vim.fs.basename(ctx.filename) ~= "README.md"
            --  end,
            --  -- Exit codes that indicate success (default { 0 })
            --  exit_codes = { 0, 1 },
            --  -- Environment variables. This can also be a function that returns a table.
            --  env = {
            --      VAR = "value",
            --  },
            --  -- Set to false to disable merging the config with the base definition
            --  inherit = true,
            --  -- When inherit = true, add these additional arguments to the command.
            --  -- This can also be a function, like args
            --  prepend_args = { "--use-tabs" },
            -- },
            -- These can also be a function that returns the formatter
            -- other_formatter = function(bufnr)
            --  return {
            --      command = "my_cmd",
            --  }
            -- end,
        },
    }
end

function M.init()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
