return {
    -- extra language support
    "NoahTheDuke/vim-just",
    { "ckipp01/stylua-nvim", lazy = true },
    { "folke/neodev.nvim", lazy = true },
    { "aaronkollasch/vim-known_hosts", ft = "known_hosts" },

    -- additional info sources
    {
        "rizzatti/dash.vim",
        cmd = {
            "Dash",
            "DashKeywords",
        },
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
    {
        "stevearc/aerial.nvim",
        cmd = {
            "AerialToggle",
            "AerialOpen",
            "AerialPrev",
            "AerialNext",
        },
        keys = {
            { "<leader>ct", "<cmd>AerialToggle<CR>", desc = "[C]ode  [T]ree" },
            { "[a", '<cmd>AerialPrev<CR>', desc = "AerialPrev" },
            { "]a", '<cmd>AerialNext<CR>', desc = "AerialNext" },
        },
        config = function()
            require("aerial").setup({
                lazy_load = false,
                min_width = 15,
                highlight_on_hover = true,
                on_attach = function(bufnr)
                    vim.keymap.set('n', '[a', '<cmd>AerialPrev<CR>', {buffer = bufnr})
                    vim.keymap.set('n', ']a', '<cmd>AerialNext<CR>', {buffer = bufnr})
                    vim.cmd([[ hi link AerialLineNC StatusLineNC ]])
                    vim.cmd([[ hi link AerialLine TabLine ]])
                end,
            })
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

    -- buffer highlighting
    {
        "itchyny/vim-cursorword",
        event = "VeryLazy",
        init = function()
            vim.cmd([[ let g:cursorword_delay = 300 ]])
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "VeryLazy",
        cmd = "TodoTelescope",
        keys = { { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "[F]ind [T]odos" } },
        opts = {},
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            user_default_options = {
                names = false,
            },
        },
    },

    -- tpope
    { "tpope/vim-sleuth", event = { "BufReadPre", "BufNewFile" } },
    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} }, -- replaces tpope/vim-commentary
    {
        "tpope/vim-fugitive",
        cmd = "Git",
        keys = { { "<leader>gs", vim.cmd.Git, desc = "[G]it [S]tart" } },
    },
    { "tpope/vim-surround", event = "VeryLazy" },
    { "tpope/vim-repeat", event = "VeryLazy" },
    "tpope/vim-characterize", -- must run at start to work properly

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

    -- colorscheme
    "sainnhe/edge",
    { "aaronkollasch/darcula", ft = "python", dev = true }, -- fork of doums/darcula

    -- <leader>fml
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = {
            { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "FML" },
        },
    },
}
