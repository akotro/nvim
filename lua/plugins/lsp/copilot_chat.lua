local M = {}

M.dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
}

M.opts = {
    debug = true, -- Enable debugging
    -- See Configuration section for rest
    window = {
        layout = "float",
        relative = "cursor",
        width = 1,
        height = 0.7,
        zindex = 5,
    },
}

M.cmd = {
    "CopilotChat",
    "CopilotChatOpen",
    "CopilotChatClose",
    "CopilotChatToggle",
    "CopilotChatStop",
    "CopilotChatReset",
    "CopilotChatSave",
    "CopilotChatLoad",
    "CopilotChatDebugInfo",
    "CopilotChatExplain",
    "CopilotChatReview",
    "CopilotChatFix",
    "CopilotChatOptimize",
    "CopilotChatDocs",
    "CopilotChatTests",
    "CopilotChatFixDiagnostic",
    "CopilotChatCommit",
    "CopilotChatCommitStaged",
}

M.keys = {
    -- {
    --     "<leader>cpc",
    --     "<cmd>CopilotChat<cr>",
    --     desc = "CopilotChat - Chat",
    --     mode = { "n", "v" },
    -- },
    {
        "<leader>cpc",
        "<cmd>CopilotChatToggle<cr>",
        desc = "CopilotChat - Toggle",
        mode = { "n", "v" },
    },
    {
        "<leader>cpr",
        "<cmd>CopilotChatReset<cr>",
        desc = "CopilotChat - Reset",
        mode = { "n", "v" },
    },
    {
        "<leader>cpq",
        function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
        end,
        desc = "CopilotChat - Quick chat",
        mode = { "n", "v" },
    },
    -- Show help actions with telescope
    -- {
    --     "<leader>cph",
    --     function()
    --         local actions = require("CopilotChat.actions")
    --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
    --     end,
    --     desc = "CopilotChat - Help actions",
    -- },
    -- Show prompts actions with telescope
    -- {
    --     "<leader>cpp",
    --     function()
    --         local actions = require("CopilotChat.actions")
    --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
    --     end,
    --     desc = "CopilotChat - Prompt actions",
    -- },
}

return M
