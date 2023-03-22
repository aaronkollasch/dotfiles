return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        local wk = require("which-key")
        wk.setup({
            operators = {
                gc = "Comments",
                ["<leader>p"] = "Paste",
                ["<leader>v"] = "Paste",
                ["<leader>gh"] = "Git History",
            },
            key_labels = {
                ["<C-Bslash>"] = "<C-\\>",
            },
        })
        wk.register({
            ["<leader>"] = {
                b = { name = "[B]uffer" },
                c = { name = "[C]ode" },
                f = { name = "[F]ind" },
                g = { name = "[G]it" },
                h = { name = "[H]unk" },
                i = { name = "[I]nspect" },
                l = { name = "[L]ocal" },
                t = { name = "[T]erm" },
                w = { name = "[W]orkspace" },
            },
            g = {
                ["("] = "Previous start of sentence",
                [")"] = "Next start of sentence",
                ["o"] = "Open URI",
            },
            Z = {
                name = "Exit",
                Z = { name = "Save and close current window" },
                Q = { name = "Close window without checking for changes" },
            },
            ["h"] = "which_key_ignore",
            ["j"] = "which_key_ignore",
            ["k"] = "which_key_ignore",
            ["l"] = "which_key_ignore",
            ["<M-b>"] = "which_key_ignore",
            ["<M-f>"] = "which_key_ignore",
            ["<S-Space>"] = "which_key_ignore",
            ["("] = "Previous start of sentence",
            [")"] = "Next start of sentence",
            ["Y"] = "Yank (copy) to end of line",
        })
        wk.register({
            ["("]  = [[Start of previous sentence]],
            [")"]  = [[Start of next sentence]],
            ["i,"] = [[inner parameter]],
            ["a,"] = [[a parameter (with comma)]],
            ["ic"] = [[inner comment]],
            ["ac"] = [[a comment (with delimiters)]],
            ["aC"] = [[a big comment (with whitespace)]],
            ["ie"] = [[entire buffer]],
            ["ae"] = [[entire buffer]],
            ["ii"] = [[inner indent]],
            ["iI"] = [[inner indent]],
            ["ai"] = [[an indent (include line above)]],
            ["aI"] = [[an indent (include above/below)]],
            ["ik"] = [[inner key]],
            ["ak"] = [[a key (with quotes)]],
            ["iv"] = [[inner value]],
            ["av"] = [[a value (with quotes)]],
            ["iS"] = [[inner subword]],
            ["aS"] = [[a subword (with delimiters)]],
            ["iu"] = [[inner URI]],
            ["au"] = [[a URI (with trailing spaces)]],
            ["il"] = [[inner line]],
            ["al"] = [[a line (with leading spaces)]],
        }, { mode = "o", prefix = "" })
    end,
}
