local icons_enabled = require("ak.opts").icons_enabled

return {
    {
        "github/copilot.vim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Copilot" },
        keys = { { "<leader>cp", "<cmd>Copilot<CR>", desc = "[C]opilot [P]anel" } },
        init = function()
            vim.g.copilot_filetypes = {
                TelescopePrompt = false,
                ["neo-tree-popup"] = false,
            }
        end,
    },
    {
        "aaronkollasch/ChatGPT.nvim",
        dev = true,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "aaronkollasch/telescope.nvim",
        },
        cmd = {
            "ChatGPT",
            "ChatGPTActAs",
            "ChatGPTEditWithInstructions",
            "ChatGPTCompleteCode",
            "ChatGPTRun",
            "ChatGPTRunCustomCodeAction",
        },
        keys = {
            { "<leader>cgo", "<cmd>ChatGPT<CR>", desc = "[C]hat [G]PT [O]pen" },
            { "<leader>cga", "<cmd>ChatGPTActAs<CR>", desc = "[C]hat [G]PT [A]ct" },
            { "<leader>cge", "<cmd>ChatGPTEditWithInstructions<CR>", desc = "[C]hat [G]PT [E]dit" },
            { "<leader>cgc", "<cmd>ChatGPTCompleteCode<CR>", desc = "[C]hat [G]PT [C]omplete" },
            -- { "<leader>cgr", "<cmd>ChatGPTRun<CR>", desc = "[C]hat [G]PT [R]un" },
            { "<leader>cgu", "<cmd>ChatGPTRunCustomCodeAction<CR>", desc = "[C]hat [G]PT custom action" },
        },
        config = function()
            vim.env.OPENAI_API_KEY = require("op.api").item.get({ "OpenAI Secret Key", "--fields", "credential" })[1]
            if not vim.env.OPENAI_API_KEY or not vim.startswith(vim.env.OPENAI_API_KEY, "sk-") then
                error("Failed to get OpenAI API key.")
            end
            require("chatgpt").setup({
                question_sign = icons_enabled and "" or "Q",
                answer_sign = icons_enabled and "󰚩" or "A",
                tokens_border = icons_enabled and { "", "" } or { "", "" },
                keymaps = {
                    close = { "<C-c>" },
                    scroll_up = { "<C-u>", "<C-e>" },
                    submit = { "<C-Enter>", "<S-CR>", "<C-l>" },
                    -- in the Sessions pane
                    select_session = { "<Space>", "<CR>" },
                },
                settings_window = {
                    border = {
                        highlight = "TelescopeBorder",
                    },
                    -- win_options = {
                    --     winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,NormalFloat:TelescopeBorder",
                    -- },
                },
                sessions_window = {
                    border = {
                        highlight = "TelescopeBorder",
                    },
                },
                chat_window = {
                    border = {
                        highlight = "TelescopeBorder",
                    },
                },
                chat_input = {
                    prompt = icons_enabled and "  " or " > ",
                    border = {
                        highlight = "TelescopeBorder",
                    },
                },
            })
        end,
    },
}
