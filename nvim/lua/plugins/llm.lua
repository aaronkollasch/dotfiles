local icons_enabled = require("ak.opts").icons_enabled

return {
    {
        "github/copilot.vim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Copilot" },
    },
    {
        "aaronkollasch/ChatGPT.nvim",
        dev = true,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
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
            { "<leader>cgo", "<cmd>ChatGPT<CR>" },
            { "<leader>cga", "<cmd>ChatGPTActAs<CR>" },
            { "<leader>cge", "<cmd>ChatGPTEditWithInstructions<CR>" },
            { "<leader>cgc", "<cmd>ChatGPTCompleteCode<CR>" },
            { "<leader>cgr", "<cmd>ChatGPTRun<CR>" },
            { "<leader>cgu", "<cmd>ChatGPTRunCustomCodeAction<CR>" },
        },
        config = function()
            vim.env.OPENAI_API_KEY = require('op.api').item.get({ 'OpenAI Secret Key', '--fields', 'credential' })[1]
            require("chatgpt").setup({
                question_sign = icons_enabled and "" or "Q",
                answer_sign = icons_enabled and "ﮧ" or "A",
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
