return {
    -- icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        cond = require("ak.opts").icons_enabled,
    },

    -- extra language support
    {
        "NoahTheDuke/vim-just",
        ft = "just",
        config = function()
            vim.cmd([[ syntax enable ]])
        end,
    },
    { "ckipp01/stylua-nvim", lazy = true },
    { "folke/neodev.nvim", lazy = true },
    {
        "aaronkollasch/vim-known_hosts",
        dev = false,
        ft = "known_hosts",
        config = function()
            vim.cmd([[ syntax enable ]])
        end,
    },
    {
        "cameron-wags/rainbow_csv.nvim",
        ft = {
            "csv",
            "tsv",
            "csv_semicolon",
            "csv_whitespace",
            "csv_pipe",
            "rfc_csv",
            "rfc_semicolon",
        },
        cmd = {
            "RainbowDelim",
            "RainbowDelimSimple",
            "RainbowDelimQuoted",
            "RainbowMultiDelim",
        },
        init = function()
            vim.g.disable_rainbow_hover = 1
        end,
        config = true,
    },

    -- additional info sources
    {
        "rizzatti/dash.vim",
        cmd = {
            "Dash",
            "DashKeywords",
        },
        -- stylua: ignore
        keys = {
            { "<leader>K",  "<Plug>DashSearch", silent = true, desc = "Dash Search" },
            { "<S-Space>K", "<Plug>DashSearch", silent = true, desc = "Dash Search" },
        },
        cond = function()
            return vim.loop.os_uname().sysname == "Darwin"
        end,
    },
    {
        "KabbAmine/zeavim.vim",
        cmd = {
            "Zeavim",
            "Docset",
            "ZeavimV",
        },
        -- stylua: ignore
        keys = {
            { "<leader>K",  "<Plug>Zeavim", silent = true, desc = "Zeal Search" },
            { "<S-Space>K", "<Plug>Zeavim", silent = true, desc = "Zeal Search" },
            { "<leader>K",  "<Plug>ZVVisSelection", mode = "x", silent = true, desc = "Zeal Search" },
            { "<S-Space>K", "<Plug>ZVVisSelection", mode = "x", silent = true, desc = "Zeal Search" },
        },
        init = function()
            vim.g.zv_disable_mapping = 1
            if vim.fn.has("unix") then
                vim.g.zv_zeal_args = "--style=gtk+"
            end
        end,
        cond = function()
            return vim.loop.os_uname().sysname ~= "Darwin"
        end,
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
        -- stylua: ignore
        keys = {
            { "<leader>wt", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "[W]orkspace [T]rouble" },
            { "<leader>bt", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "[B]uffer [T]rouble" },
        },
        opts = {},
    },
    {
        "BooleanCube/keylab.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        lazy = true,
        keys = {
            { "<leader>kl", "<cmd>lua require('keylab').start()<cr>", desc = "[K]ey[L]ab" },
        },
        opts = {},
    },
    {
        "ecthelionvi/NeoComposer.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        event = "VeryLazy",
        config = function()
            local opts = {
                keymaps = {
                    play_macro = "Q",
                    yank_macro = "yq",
                    stop_macro = "cq",
                    toggle_record = "q",
                    cycle_next = "<c-m>",
                    cycle_prev = "<c-s-m>",
                    toggle_macro_menu = "<c-q>",
                },
            }
            require("NeoComposer").setup(opts)
            require("NeoComposer.store").load_macros_from_database()
            require("NeoComposer.state").set_queued_macro_on_startup()
        end,
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
        opts = {
            keywords = {
                TODO = { alt = { "todo", "unimplemented" } },
            },
            highlight = {
                pattern = {
                    [[.*<(KEYWORDS)\s*:]],
                    [[.*<(KEYWORDS)\s*!\(]],
                },
                comments_only = false,
            },
            search = {
                pattern = [[\b(KEYWORDS)(:|!\()]],
            },
        },
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
        keys = { { "<leader>ih", "<cmd>ColorizerToggle<CR>", desc = "[I]nspect [H]excodes" } },
        opts = {
            user_default_options = {
                RRGGBBAA = true,
                AARRGGBB = true,
                css_fn = true,
            },
        },
    },
    {
        "tzachar/highlight-undo.nvim",
        event = "VeryLazy",
        opts = {
            hlgroup = "IncSearch",
            duration = 200,
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
        -- stylua: ignore
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "[G]it [S]tart" },
            { "<leader>gc", function() vim.cmd.Git("commit -v") end, desc = "[G]it [C]ommit" },
            { "<leader>gb", function() vim.cmd.Git("blame") end, desc = "[G]it [B]lame" },
        },
    },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} }, -- replaces tpope/vim-surround
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-characterize", keys = { { "<leader>ic", "<Plug>(characterize)", desc = "[I]nspect [C]haracter" } } },

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
        "aaronkollasch/treesj",
        -- stylua: ignore
        keys = {
            { "gS", function() require('treesj').toggle() end, mode = { "n", "x" }, desc = "Toggle arguments" },
            { "gJ", function() require('treesj').join() end, mode = { "n", "x" }, desc = "Join arguments" },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            use_default_keymaps = false,
        },
    },
    { "mrjones2014/lua-gf.nvim", event = { "BufReadPre *.lua", "BufNewFile *.lua" } },
    {
        "chrishrb/gx.nvim",
        keys = {
            { "gx", nil, mode = { "n", "x" }, desc = "Open URL under cursor" },
        },
        -- event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
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
        -- stylua: ignore
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
        dev = false,
        priority = 1000,
        config = function()
            require("ak.colors")
        end,
    },
    { "aaronkollasch/darcula", dev = false, ft = "python" }, -- fork of doums/darcula
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
