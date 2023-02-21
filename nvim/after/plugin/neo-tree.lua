-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
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
})

local file_renderers = require("neo-tree.setup").config.filesystem.renderers.file
table.insert(file_renderers[3].content, 3, {
    "harpoon_index",
    zindex = 10,
})

-- map <leader>lt to ":Neotree reveal toggle<cr>"
vim.keymap.set("n", "<leader>lt", function()
    require("neo-tree.command").execute({
        reveal = true,
        toggle = true,
    })
end, { desc = "[L]ocal  [T]ree" })
