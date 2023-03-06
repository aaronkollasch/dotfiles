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
    {
        "itchyny/vim-cursorword",
        event = "VeryLazy",
        init = function()
            vim.cmd([[ let g:cursorword_delay = 300 ]])
        end,
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

    -- textobjects, see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",        dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- al/il for the current line
    { "kana/vim-textobj-indent",      dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",      dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter",   dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- a,/i, for an argument to a function
    { "vimtaku/vim-textobj-keyvalue", dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ak/ik and av/iv for key/value
    { "glts/vim-textobj-comment",     dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- ac/ic for a comment
    { "jceb/vim-textobj-uri",         dependencies = "kana/vim-textobj-user", event = "VeryLazy" }, -- au/iu for a URI, also adds go to open URL
    {
        "preservim/vim-textobj-sentence",                                                           -- as/is for the current sentence (replaces built-in objects/motions)
        dependencies = "kana/vim-textobj-user",
        event = "VeryLazy",
        config = function ()
            vim.fn["textobj#sentence#init"]()
        end
    },
    {
        "Julian/vim-textobj-variable-segment",                                                      -- aS/iS for a subword, separated by camelCase or underscore
        dependencies = "kana/vim-textobj-user",
        event = "VeryLazy",
        init = function()
            vim.g.loaded_textobj_variable_segment = 1
        end,
        config = function()
            vim.cmd([[
            call textobj#user#plugin('variable', {
                \ '-': {
                \     'sfile': expand('<sfile>:p'),
                \     'select-a': 'aS',  'select-a-function': 'textobj#variable_segment#select_a',
                \     'select-i': 'iS',  'select-i-function': 'textobj#variable_segment#select_i',
                \ }})
            ]])
        end
    },

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
