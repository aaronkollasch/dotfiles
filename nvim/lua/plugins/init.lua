return {
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground", event = "VeryLazy" },
    { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },

    -- extra language support
    "NoahTheDuke/vim-just",
    { "ckipp01/stylua-nvim", lazy = true },
    { "folke/neodev.nvim", lazy = true },
    "aaronkollasch/vim-known_hosts",

    -- additional info sources
    {
        "rizzatti/dash.vim",
        keys = { { "<leader>K", "<Plug>DashSearch", silent = true, desc = "Dash Search" } },
    },

    -- Code Actions
    {
        "kosayoda/nvim-lightbulb",
        dependencies = "antoinemadec/FixCursorHold.nvim",
        event = "VeryLazy",
        opts = {
            -- LSP client names to ignore
            -- Example: {"lua_ls", "null-ls"}
            ignore = {
                "marksman",
            },
            autocmd = { enabled = true },
        },
    },

    -- tree view
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
        },
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },

    -- splits management / tmux compatibility
    { "aaronkollasch/vim-bufkill", event = "VeryLazy" },
    {
        "markstory/vim-zoomwin",
        cmd = "ZoomToggle",
        keys = { { "<leader>z", nil, desc = "ZoomToggle" } },
    }, -- <leader>z to zoom, see also troydm/zoomwintab.vim

    -- hints
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                operators = {
                    gc = "Comments",
                    ["<space>p"] = "Paste",
                    ["<space>v"] = "Paste",
                },
            })
        end,
    },

    -- tpope
    "tpope/vim-sleuth",
    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} }, -- replaces tpope/vim-commentary
    {
        "tpope/vim-fugitive",
        cmd = "Git",
        keys = { { "<leader>gs", vim.cmd.Git, desc = "[G]it [S]tart" } },
    },
    { "tpope/vim-surround", event = "VeryLazy" },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-characterize", event = "VeryLazy" },

    -- text actions
    {
        "junegunn/vim-easy-align",
        keys = {
            -- n: Start interactive EasyAlign for a motion/text object (e.g. gaip)
            -- x: Start interactive EasyAlign in visual mode (e.g. vipga)
            { "gl", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
        },
    },

    -- better <leader>p
    { "inkarkat/vim-ReplaceWithRegister", event = "VeryLazy" },

    -- textobjects, see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",      dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- al/il for the current line
    { "kana/vim-textobj-indent",    dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",    dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter", dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- a,/i, for an argument to a function
    { "glts/vim-textobj-comment",   dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ac/ic for a comment

    -- colorscheme
    "sainnhe/edge",

    -- <leader>fml
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = {
            { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "FML" },
        },
    },
}