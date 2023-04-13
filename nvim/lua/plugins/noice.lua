local cmdline_icons = {
    search_down = { icon = " " },
    search_up = { icon = " " },
}
if not require("ak.opts").icons_enabled then
    cmdline_icons = {
        cmdline = { icon = ":" },
        search_down = { icon = "/⌄" },
        search_up = { icon = "?^" },
        filter = { icon = "$" },
        lua = { icon = "☾" },
        help = { icon = "?" },
    }
end

return {
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline",
                format = cmdline_icons,
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
