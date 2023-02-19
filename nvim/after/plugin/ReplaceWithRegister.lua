-- remove existing ReplaceWithRegister keymaps
vim.keymap.del("n", "grr")
vim.keymap.del("x", "gr")

-- replace with register
vim.keymap.set("n", "<leader>p",  "<Plug>ReplaceWithRegisterOperator", { desc = "[P]aste from register (operator)" })
vim.keymap.set("n", "<leader>pp", "<Plug>ReplaceWithRegisterLine", { desc = "[P]aste line from register" })
vim.keymap.set("x", "<leader>p",  "<Plug>ReplaceWithRegisterVisual", { desc = "[P]aste from register" })

-- replace with system clipboard
vim.keymap.set("n", "<leader>v",  "\"+<Plug>ReplaceWithRegisterOperator", { desc = "[P]aste from clipboard (operator)" })
vim.keymap.set("n", "<leader>vv", "\"+<Plug>ReplaceWithRegisterLine", { desc = "[P]aste line from clipboard" })
vim.keymap.set("x", "<leader>v",  "\"+<Plug>ReplaceWithRegisterVisual", { desc = "[P]aste from clipboard" })
