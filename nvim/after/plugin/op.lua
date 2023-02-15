vim.keymap.set("n", "<leader>op", require("op").op_insert, { desc = "[O]ne[P]assword" })
-- vim.keymap.set("n", "<leader>op", require('op.sidebar').toggle, { desc = '[O]ne[P]assword' })

require("op").setup({
    sidebar = {
        side = "left",
    },
    mappings = {
        ["q"] = function()
            require("op.sidebar").close()
        end,
    },
})
