return {
    -- icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        cond = require("ak.opts").icons_enabled,
    },

    -- extra language support
    { "NoahTheDuke/vim-just", ft = "just", config = function ()
        vim.cmd([[ syntax enable ]])
    end },
    { "ckipp01/stylua-nvim", lazy = true },
    { "folke/neodev.nvim", lazy = true },
    { "aaronkollasch/vim-known_hosts", dev = true, ft = "known_hosts", config = function ()
        vim.cmd([[ syntax enable ]])
    end },

    -- additional info sources
    {
        "rizzatti/dash.vim",
        cmd = {
            "Dash",
            "DashKeywords",
        },
        keys = {
            { "<leader>K",  "<Plug>DashSearch", silent = true, desc = "Dash Search" },
            { "<S-Space>K", "<Plug>DashSearch", silent = true, desc = "Dash Search" },
        },
        enabled = function ()
            return vim.loop.os_uname().sysname == "Darwin"
        end
    },
    {
        "KabbAmine/zeavim.vim",
        cmd = {
            "Zeavim",
            "Docset",
            "ZeavimV",
        },
        keys = {
            { "<leader>K",  "<Plug>Zeavim", silent = true, desc = "Zeal Search" },
            { "<S-Space>K", "<Plug>Zeavim", silent = true, desc = "Zeal Search" },
            { "<leader>K",  "<Plug>ZVVisSelection", mode = "x", silent = true, desc = "Zeal Search" },
            { "<S-Space>K", "<Plug>ZVVisSelection", mode = "x", silent = true, desc = "Zeal Search" },
        },
        init = function()
            vim.g.zv_disable_mapping = 1
            if vim.fn.has("unix") then
                vim.g.zv_zeal_args = '--style=gtk+'
            end
        end,
        enabled = function ()
            return vim.loop.os_uname().sysname ~= "Darwin"
        end
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

    -- popups
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
        "folke/trouble.nvim",
        cmd = {
            "Trouble",
            "TroubleClose",
            "TroubleToggle",
            "TroubleRefresh",
        },
        keys = {
            { "<leader>wt", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "[W]orkspace [T]rouble" },
            { "<leader>bt", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "[B]uffer [T]rouble" },
        },
        opts = {},
    },

    -- buffer highlighting
    {
        "itchyny/vim-cursorword",
        event = "VeryLazy",
        init = function()
            vim.g.cursorword_delay = 300
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
        ft = {
            "css",
            "javascript",
            "html",
        },
        cmd = {
            "ColorizerToggle",
            "ColorizerAttachToBuffer",
            "ColorizerReloadAllBuffers",
        },
        keys = { { "<leader>ch",  "<cmd>ColorizerToggle<CR>", desc = "[C]olor [H]excodes" } },
        opts = {
            user_default_options = {
                RRGGBBAA = true,
                AARRGGBB = true,
                css_fn = true,
            },
        },
    },

    -- tpope
    { "tpope/vim-sleuth", event = { "BufReadPre", "BufNewFile" } },
    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} }, -- replaces tpope/vim-commentary
    {
        "tpope/vim-fugitive",
        cmd = {
            "G",
            "Git",
            "Gdiff",
            "Gdiffsplit",
        },
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "[G]it [S]tart" },
            { "<leader>gc", function() vim.cmd.Git("commit -v") end, desc = "[G]it [C]ommit" },
            { "<leader>gb", function() vim.cmd.Git("blame") end, desc = "[G]it [B]lame" },
        },
    },
    { "tpope/vim-surround", event = "VeryLazy" },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-characterize", keys = { { "<leader>ic", "<Plug>(characterize)", desc="Characterize under cursor" } } },

    -- text actions
    {
        "junegunn/vim-easy-align",
        cmd = "EasyAlign",
        keys = {
            -- n: Start interactive EasyAlign for a motion/text object (e.g. gaip)
            -- x: Start interactive EasyAlign in visual mode (e.g. vipga)
            { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
        },
    },
    {
        'aaronkollasch/treesj',
        keys = {
            { "gS", function() require('treesj').toggle() end, mode = { "n", "x" }, desc = "Toggle arguments" },
            { "gJ", function() require('treesj').join() end, mode = { "n", "x" }, desc = "Join arguments" },
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            use_default_keymaps = false,
        },
    },
    -- {
    --     "smjonas/inc-rename.nvim",
    --     keys = {
    --         { "<leader>rn",function()
    --             return ":IncRename " .. vim.fn.expand("<cword>")
    --         end, expr = true, desc = "[R]e[N]ame" },
    --     },
    --     opts = {},
    -- },
    -- {
    --     "smjonas/live-command.nvim",
    --     cmd = { "Norm", "Reg" },
    --     config = function()
    --         require("live-command").setup {
    --             commands = {
    --                 Norm = { cmd = "norm" },
    --                 Reg = {
    --                     cmd = "norm",
    --                     -- This will transform ":5Reg a" into ":norm 5@a"
    --                     args = function(opts)
    --                         return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
    --                     end,
    --                     range = "",
    --                 },
    --             },
    --         }
    --     end,
    -- },

    -- get github permalink
    {
        "knsh14/vim-github-link",
        cmd = {
            "GetCommitLink",
            "GetCurrentBranchLink",
            "GetCurrentCommitLink",
        },
        keys = {
            { "<leader>gp", ":GetCurrentCommitLink<CR>", mode = { "n", "x" }, silent = true, desc = "[G]it [P]ermalink" },
        },
    },

    -- better <leader>p
    { "inkarkat/vim-ReplaceWithRegister", event = "VeryLazy" },

    -- better <leader>y over SSH
    {
        "ojroques/nvim-osc52",
        lazy = true,
        init = function()
            local function copy()
                if
                    vim.v.event.operator == "y"
                    and vim.v.event.regname == "+"
                    and (vim.env.SSH_TTY ~= nil or vim.env.TMUX ~= nil)
                then
                    require("osc52").copy_register("+")
                end
            end

            vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
        end,
        opts = {},
    },

    -- colorscheme
    {
        "aaronkollasch/edge",
        dev = true,
        priority = 1000,
        config = function()
            require("ak.colors")
        end,
    },
    { "aaronkollasch/darcula", dev = true, ft = "python" }, -- fork of doums/darcula
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            day_brightness = 0.25,
            lualine_bold = true,
        },
    },

    -- <leader>fml
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = {
            { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "FML" },
        },
    },
}
