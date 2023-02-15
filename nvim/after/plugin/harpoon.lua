require("harpoon").setup({
    global_settings = {
        ["show_file_keymaps"] = true,
        ["file_keymaps"] = { "g", "t", "y", "s" },
        -- ["file_keymaps"] = { "h", "t", "n", "s" },
    },
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd to Harpoon" })
vim.keymap.set("n", "<C-n>", ui.toggle_quick_menu, { desc = "Toggle Harpoon menu" })

vim.keymap.set("n", "<C-g>", function()
    ui.nav_file(1)
end, { desc = "Goto Harpoon file 1" })
vim.keymap.set("n", "<C-t>", function()
    ui.nav_file(2)
end, { desc = "Goto Harpoon file 2" })
vim.keymap.set("n", "<C-y>", function()
    ui.nav_file(3)
end, { desc = "Goto Harpoon file 3" })
vim.keymap.set("n", "<C-s>", function()
    ui.nav_file(4)
end, { desc = "Goto Harpoon file 4" })
