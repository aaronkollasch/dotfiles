return {
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },

    -- LSP support with lsp-zero
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },

            -- Additional dependencies
            { "simrat39/rust-tools.nvim" },
        },
    },

    -- extra language support
    "NoahTheDuke/vim-just",
    "ckipp01/stylua-nvim",
    "folke/neodev.nvim",
    "aaronkollasch/vim-known_hosts",

    -- additional info sources
    "rizzatti/dash.vim",
    { "mrjones2014/op.nvim", build = "make install" },

    -- Code Actions
    {
        "kosayoda/nvim-lightbulb",
        dependencies = "antoinemadec/FixCursorHold.nvim",
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },

    -- statuscolumn
    "lewis6991/gitsigns.nvim",

    -- tree view
    {
        -- 'ThePrimeagen/harpoon',
        -- '~/GitHub/harpoon',
        "aaronkollasch/harpoon",
        branch = "add-file-keymap-hints",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    "mbbill/undotree",

    -- splits management / tmux compatibility
    "mrjones2014/smart-splits.nvim", -- replaces christoomey/vim-tmux-navigator
    "aaronkollasch/vim-bufkill",
    "markstory/vim-zoomwin", -- <leader>z to zoom, see also troydm/zoomwintab.vim

    -- hints
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                operators = {
                    gc = "Comments",
                    ["<space>p"] = "Paste",
                    ["<space>v"] = "Paste",
                }
            })
        end,
    },

    -- tpope
    "numToStr/Comment.nvim", -- replaces tpope/vim-commentary
    "tpope/vim-sleuth",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "tpope/vim-characterize",

    -- text actions
    "junegunn/vim-easy-align",

    -- better <leader>p
    "inkarkat/vim-ReplaceWithRegister",

    -- textobjects, see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",      dependencies = "kana/vim-textobj-user" }, -- al/il for the current line
    { "kana/vim-textobj-indent",    dependencies = "kana/vim-textobj-user" }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",    dependencies = "kana/vim-textobj-user" }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter", dependencies = "kana/vim-textobj-user" }, -- a,/i, for an argument to a function
    { "glts/vim-textobj-comment",   dependencies = "kana/vim-textobj-user" }, -- ac/ic for a comment

    -- colorscheme
    "sainnhe/edge",

    -- <leader>fml
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = {
            { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "FML" }
        },
    },
}
