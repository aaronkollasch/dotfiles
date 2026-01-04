local icons_enabled = require("ak.opts").icons_enabled

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
        -- "SmiteshP/nvim-navbuddy",
        "aaronkollasch/nvim-navbuddy",
        dev = false,
        dependencies = {
            -- "SmiteshP/nvim-navic",
            {
                "aaronkollasch/nvim-navic",
                dev = false,
                lazy = true,
                opts = {
                    icons = {
                        enabled = icons_enabled,
                    },
                    lsp = {
                        auto_attach = true,
                        preference = nil,
                    },
                },
            },
            "MunifTanjim/nui.nvim",
        },
        lazy = true,
        cmd = "Navbuddy",
        keys = {
            { "<leader>ct", "<cmd>Navbuddy<CR>", desc = "[C]ode  [T]ree" },
            -- { "<leader>cs", "<cmd>Telescope navbuddy<CR>", desc = "[C]ode  [S]ymbols" },
        },
        opts = function()
            local actions = require("nvim-navbuddy.actions")
            local node_markers = {
                enabled = true,
                icons = {
                    leaf = "  ",
                    leaf_selected = " 󰗼 ",
                    branch = " ",
                },
            }
            if not icons_enabled then
                node_markers.icons.leaf = "  "
                node_markers.icons.leaf_selected = "→□"
                node_markers.icons.branch = " >"
            end
            return {
                window = {
                    border = "rounded",
                },
                node_markers = node_markers,
                icons = {
                    enabled = icons_enabled,
                },
                mappings = {
                    ["<C-j>"] = actions.next_sibling(),
                    ["<Down>"] = actions.next_sibling(),
                    ["<C-k>"] = actions.previous_sibling(),
                    ["<Up>"] = actions.previous_sibling(),
                    ["<C-h>"] = actions.parent(),
                    ["<Left>"] = actions.parent(),
                    ["<C-l>"] = actions.children(),
                    ["<Right>"] = actions.children(),
                },
                lsp = {
                    auto_attach = true,
                    preference = nil,
                },
            }
        end,
    },
}
