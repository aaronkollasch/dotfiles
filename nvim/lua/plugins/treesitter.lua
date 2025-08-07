local ts_opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
        "vimdoc",
        "vim",
        "python",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "bash",
        "regex",
        "query",
        "markdown",
        "markdown_inline",
        "rst",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "csv", "tsv" },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        disable = { "tmux" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = false,
            node_incremental = "v",
            scope_incremental = "<M-v>",
            node_decremental = "<C-v>",
        },
    },

    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },

    matchup = {
        enable = true,
    },
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = ts_opts,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    { -- show code context in top line(s)
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<leader>cc", "<cmd>TSContextToggle<CR>", desc = "[C]ode  [C]ontext" },
        },
        opts = {
            multiline_threshold = 2,
        },
    },
}
