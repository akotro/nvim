local M = {}

M.dependencies = "kevinhwang91/promise-async"

M.keys = {
    {
        "<leader>zo",
        function()
            require("ufo").openAllFolds()
        end,
        "Open All Folds",
    },
    {
        "<leader>zc",
        function()
            require("ufo").closeAllFolds()
        end,
        "Close All Folds",
    },
}

function M.config()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" -- %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, { chunkText, hlGroup })
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
    end

    ---@diagnostic disable-next-line: missing-fields
    require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
    })
    local bufnr = vim.api.nvim_get_current_buf()
    require("ufo").setFoldVirtTextHandler(bufnr, handler)
end

return M
