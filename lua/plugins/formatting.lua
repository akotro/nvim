local M = {}

function M.init_msg_progress(title, msg)
    return require("fidget.progress").handle.create({
        title = title,
        message = msg,
        lsp_client = { name = ">>" }, -- the fake lsp client name
        percentage = nil, -- skip percentage field
    })
end

function M.get_fmt_info(conform, format_args)
    if conform == nil then
        conform = pcall(require, "conform")
    end

    -- get current formatter names
    if conform then
        local list_formatters = conform.list_formatters or function()
            return {}
        end
        local list_formatters_to_run = conform.list_formatters_to_run or function()
            return {}
        end

        local formatters = list_formatters()
        local fmt_names = {}

        if not vim.tbl_isempty(formatters) then
            fmt_names = vim.tbl_map(function(f)
                return f.name
            end, formatters)
        elseif list_formatters_to_run() then
            fmt_names = { "lsp" }
        else
            return
        end

        local fmt_info = "fmt: " .. table.concat(fmt_names, "/")
        return fmt_info
    end

    return ""
end

function M.format(format_args)
    local have_fmt, conform = pcall(require, "conform")
    if have_fmt then
        local fmt_info = M.get_fmt_info(conform, format_args)
        local msg_handle = M.init_msg_progress(fmt_info)

        -- format with auto close popup, and notify if err
        conform.format(format_args, function(err)
            msg_handle:finish()
            -- if err then
            --     vim.notify(err, vim.log.levels.WARN, { title = fmt_info })
            -- end
        end)
    else
        vim.lsp.buf.format(format_args)
    end
end

M.keys = {
    {
        "<leader>lf",
        function()
            M.format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
    },
}

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
            sh = { "shfmt" },
            -- Conform will run multiple formatters sequentially
            go = { "goimports", "gofmt" },
            -- Use a sub-list to run only the first available formatter
            html = { "prettierd", "prettier", stop_after_first = true },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            markdown = { "deno_fmt" },
            tex = { "latexindent" },
            -- You can use a function here to determine the formatters dynamically
            python = function(bufnr)
                if require("conform").get_formatter_info("ruff_format", bufnr).available then
                    return { "ruff_format" }
                else
                    return { "black" }
                end
            end,
            typst = { "typstfmt" },
            nix = { "alejandra" },
            yaml = { "yamlfmt" },
            c = { "clang_format" },
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
            local format_args = { timeout_ms = 200, lsp_fallback = true }

            local fmt_info = M.get_fmt_info(format_args)
            local msg_handle = M.init_msg_progress(fmt_info)

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
                msg_handle:finish()
                -- if err then
                --     vim.notify(err, vim.log.levels.WARN, { title = fmt_info })
                -- end

                if err and err:match("timeout$") then
                    slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
            end

            return format_args, on_format
        end,

        format_after_save = function(bufnr)
            local format_args = { lsp_fallback = true }

            -- local fmt_info = M.get_fmt_info(format_args)
            -- local msg_handle = M.init_msg_progress(fmt_info)

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

            local function on_format(err)
                -- msg_handle:finish()
                -- if err then
                --     vim.notify(err, vim.log.levels.WARN, { title = fmt_info })
                -- end
            end

            return format_args, on_format
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
            clang_format = {
                prepend_args = {
                    "--fallback-style=Google",
                },
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
