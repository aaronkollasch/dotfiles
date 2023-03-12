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
                ["<space>p"] = "Paste",
                ["<space>v"] = "Paste",
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
            ["ii"] = [[same-indent (stop at newlines)]],
            ["iI"] = [[same-indent (not higher)]],
            ["ai"] = [[same-indent (include newlines)]],
            ["aI"] = [[same-indent (not higher)]],
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
