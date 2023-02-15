local splits = require("smart-splits")

splits.setup({
    -- whether to wrap to opposite side when cursor is at an edge
    -- e.g. by default, moving left at the left edge will jump
    -- to the rightmost window, and vice versa, same for up/down.
    wrap_at_edge = false,
})

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set("n", "<A-h>", splits.resize_left)
vim.keymap.set("n", "<A-j>", splits.resize_down)
vim.keymap.set("n", "<A-k>", splits.resize_up)
vim.keymap.set("n", "<A-l>", splits.resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", splits.move_cursor_left)
vim.keymap.set("n", "<C-j>", splits.move_cursor_down)
vim.keymap.set("n", "<C-k>", splits.move_cursor_up)
vim.keymap.set("n", "<C-l>", splits.move_cursor_right)
