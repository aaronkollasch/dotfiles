return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {
                PATH = "append",
            },
        },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },

        -- Snippets
        {
            "L3MON4D3/LuaSnip",
            dependencies = { "rafamadriz/friendly-snippets" },
        },

        -- Additional dependencies
        -- { "mrcjkb/rustaceanvim" },
        { "stevearc/conform.nvim" },
    },
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonUpdate", "LspInfo", "LspInstall" },
    config = function()
        require("ak.lsp")
    end,
}
