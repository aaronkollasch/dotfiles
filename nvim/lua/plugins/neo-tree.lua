return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        -- map <leader>lt to ":Neotree reveal toggle<cr>"
        { "<leader>lt", "<cmd>Neotree reveal toggle<cr>", desc = "[L]ocal  [T]ree" },
    },
    config = function()
        local icons_enabled = require("ak.opts").icons_enabled

        -- Unless you are still migrating, remove the deprecated commands from v1.x
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        if icons_enabled then
            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"
        else
            vim.fn.sign_define("DiagnosticSignError", { text = "E ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = "W ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = "I ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "H", texthl = "DiagnosticSignHint" })
        end

        local config = {
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = icons_enabled,
            default_component_configs = {
                icon = {},
                indent = {},
                git_status = { symbols = {} },
            },
            window = {
                mappings = {
                    ["Z"] = "expand_all_nodes",
                },
            },
            filesystem = {
                components = {
                    harpoon_index = function(config, node, state)
                        local Marked = require("harpoon.mark")
                        local path = node:get_id()
                        local success, index = pcall(Marked.get_index_of, path)
                        if success and index and index > 0 then
                            return {
                                text = string.format(" ⥤ %d", index), -- <-- Add your favorite harpoon like arrow here
                                highlight = config.highlight or "NeoTreeDirectoryIcon",
                            }
                        else
                            return {}
                        end
                    end,
                },
                hijack_netrw_behavior = "open_current",
            },
        }

        if not icons_enabled then
            local components = config.default_component_configs
            components.indent.expander_collapsed = ">"
            components.indent.expander_expanded = "v"
            components.git_status.symbols.conflict = "!"
            components.git_status.symbols.ignored = "I"
            components.git_status.symbols.modified = "*"
            components.git_status.symbols.renamed = "→"
            components.git_status.symbols.staged = "☑︎"
            components.git_status.symbols.unstaged = "❏"
            components.git_status.symbols.untracked = "?"
            components.icon.folder_closed = "◆"
            components.icon.folder_empty = "◇"
            components.icon.folder_empty_open = "◇"
            components.icon.folder_open = "✢"
        end

        require("neo-tree").setup(config)

        local file_renderers = require("neo-tree.setup").config.filesystem.renderers.file
        table.insert(file_renderers[3].content, 3, {
            "harpoon_index",
            zindex = 10,
        })
    end,
}
