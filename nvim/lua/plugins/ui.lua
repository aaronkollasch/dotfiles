return {
    -- statuscol
    {
        "kosayoda/nvim-lightbulb",
        dependencies = "antoinemadec/FixCursorHold.nvim",
        event = "VeryLazy",
        opts = {
            -- LSP client names to ignore
            -- Example: {"lua_ls", "null-ls"}
            ignore = {
                clients = {
                    "marksman",
                },
            },
            autocmd = { enabled = true },
        },
        cond = false,
    },
    {
        "luukvbaal/statuscol.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local builtin = require("statuscol.builtin")
            return {
                relculright = true,
                setopt = true,
                segments = {
                    {
                        sign = {
                            name = {
                                "LightBulbSign",
                                "Dap",
                                "neotest",
                                "Diagnostic",
                                "todo",
                            },
                            namespace = { "diagnostic/sign" },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = false,
                        },
                        click = "v:lua.ScSa",
                    },
                    { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
                    {
                        sign = {
                            namespace = { "gitsigns" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = false,
                            fillchar = " ",
                            fillcharhl = "StatusColumnSeparator",
                        },
                        click = "v:lua.ScSa",
                    },
                },
                ft_ignore = {
                    "help",
                    -- "vim",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "noice",
                    "lazy",
                    "toggleterm",
                },
            }
        end,
    },
}
