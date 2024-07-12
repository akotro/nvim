local M = {}

M.opts = {
    bar = {
        sources = function(buf, _)
            local sources = require("dropbar.sources")

            local filename = {
                get_symbols = function(buff, win, cursor)
                    local symbols = sources.path.get_symbols(buff, win, cursor)
                    return { symbols[#symbols] }
                end,
            }

            local utils = require("dropbar.utils")
            if vim.bo[buf].ft == "markdown" then
                return {
                    -- sources.path,
                    filename,
                    sources.markdown,
                }
            end
            if vim.bo[buf].buftype == "terminal" then
                return {
                    sources.terminal,
                }
            end
            return {
                -- sources.path,
                filename,
                utils.source.fallback({
                    sources.lsp,
                    sources.treesitter,
                }),
            }
        end,
    },
}

return M
