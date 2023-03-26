local icons_enabled = require("ak.opts").icons_enabled

local navic_icons = {}
if icons_enabled then
    navic_icons = {
        File          = "󰈙 ",
        Module        = " ",
        Namespace     = "󰌗 ",
        Package       = " ",
        Class         = "󰌗 ",
        Method        = "󰊕 ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "󰕘 ",
        Interface     = "󰕘 ",
        Function      = "󰊕 ",
        Variable      = "󰫧 ",
        Constant      = "󰏿 ",
        String        = "󰀬 ",
        Number        = "󰎠 ",
        Boolean       = "◩ ",
        Array         = "󰅪 ",
        Object        = "󰅩 ",
        Key           = "󰌋 ",
        Null          = "󰟢 ",
        EnumMember    = " ",
        Struct        = "󰌗 ",
        Event         = " ",
        Operator      = "󰆕 ",
        TypeParameter = "󰊄 ",
    }
else
    navic_icons = {
        File          = "",
        Module        = "",
        Namespace     = "",
        Package       = "",
        Class         = "",
        Method        = "",
        Property      = "",
        Field         = "",
        Constructor   = "",
        Enum          = "",
        Interface     = "",
        Function      = "",
        Variable      = "",
        Constant      = "",
        String        = "",
        Number        = "",
        Boolean       = "",
        Array         = "",
        Object        = "",
        Key           = "",
        Null          = "",
        EnumMember    = "",
        Struct        = "",
        Event         = "",
        Operator      = "",
        TypeParameter = "",
    }
end

return {
    -- {
    --     "stevearc/aerial.nvim",
    --     cmd = {
    --         "AerialToggle",
    --         "AerialOpen",
    --         "AerialPrev",
    --         "AerialNext",
    --     },
    --     keys = {
    --         { "<leader>ct", "<cmd>AerialToggle<CR>", desc = "[C]ode  [T]ree" },
    --         { "[a", '<cmd>AerialPrev<CR>', desc = "AerialPrev" },
    --         { "]a", '<cmd>AerialNext<CR>', desc = "AerialNext" },
    --     },
    --     config = function()
    --         require("aerial").setup({
    --             lazy_load = false,
    --             min_width = 15,
    --             highlight_on_hover = true,
    --             on_attach = function(bufnr)
    --                 vim.keymap.set('n', '[a', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    --                 vim.keymap.set('n', ']a', '<cmd>AerialNext<CR>', {buffer = bufnr})
    --                 vim.cmd([[ hi link AerialLineNC StatusLineNC ]])
    --                 vim.cmd([[ hi link AerialLine TabLine ]])
    --             end,
    --         })
    --     end,
    -- },
    {
        "aaronkollasch/nvim-navbuddy",
        dev = true,
        dependencies = {
            "neovim/nvim-lspconfig",
            {
                "SmiteshP/nvim-navic",
                opts = {
                    icons = navic_icons,
                },
            },
            "MunifTanjim/nui.nvim"
        },
        lazy = true,
        cmd = "Navbuddy",
        keys = {
            { "<leader>ct", "<cmd>Navbuddy<CR>", desc = "[C]ode  [T]ree" },
        },
        opts = {
            icons = navic_icons,
        },
    },
}
