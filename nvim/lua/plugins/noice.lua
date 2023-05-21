local cmdline_format = {
    cmdline = {},
    search_down = {
        icon = " ",
        view = "cmdline",
    },
    search_up = {
        icon = " ",
        view = "cmdline",
    },
    filter = {},
    lua = {},
    help = {},
}
local notify_icons = {}

if not require("ak.opts").icons_enabled then
    cmdline_format.cmdline.icon = ":"
    cmdline_format.search_down.icon = "/⌄"
    cmdline_format.search_up.icon = "?^"
    cmdline_format.filter.icon = "$"
    cmdline_format.lua.icon = "☾"
    cmdline_format.help.icon = "?"
    notify_icons = {
        ERROR = "E:",
        WARN = "W:",
        HINT = "H:",
        INFO = "I:",
        TRACE = "T:",
    }
end

return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        keys = {
            { "<leader>mf", "<cmd>Telescope notify<cr>", desc = "[M]essage [F]ind" },
        },
        opts = {
            icons = notify_icons,
        },
    },
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
        cmd = "Noice",
        keys = {
            { "<leader>mc", "<cmd>Noice dismiss<cr>", desc = "[M]essage [C]lear" },
        },
        opts = {
            cmdline = {
                -- view = "cmdline",
                format = cmdline_format,
            },
            lsp = {
                hover = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        },
    },
}
