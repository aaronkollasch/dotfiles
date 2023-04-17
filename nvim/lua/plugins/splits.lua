return {
    {
        "aaronkollasch/vim-bufkill",
        event = "VeryLazy",
        keys = {
            { "<leader>bud", "<Plug>BufKillUndo", desc = "[B]uffer [U]n[D]o kill" },
        },
    },
    {
        "markstory/vim-zoomwin",
        cmd = "ZoomToggle",
        keys = { { "<leader>z", nil, desc = "ZoomToggle" } },
    }, -- <leader>z to zoom, see also troydm/zoomwintab.vim or anuvyklack/windows.nvim
    {
        "mrjones2014/smart-splits.nvim", -- replaces christoomey/vim-tmux-navigator
        keys = {
            { "<A-h>", nil, desc = "Resize window left" },
            { "<A-j>", nil, desc = "Resize window down" },
            { "<A-k>", nil, desc = "Resize window up" },
            { "<A-l>", nil, desc = "Resize window right" },
            { "<C-h>", nil, desc = "Move left one window" },
            { "<C-j>", nil, desc = "Move down one window" },
            { "<C-k>", nil, desc = "Move up one window" },
            { "<C-l>", nil, desc = "Move right one window" },
        },
        config = function()
            local splits = require("smart-splits")

            splits.setup({
                -- whether to wrap to opposite side when cursor is at an edge
                -- e.g. by default, moving left at the left edge will jump
                -- to the rightmost window, and vice versa, same for up/down.
                wrap_at_edge = false,

                -- enable or disable a multiplexer integration
                -- set to false to disable, otherwise
                -- it will default to tmux if $TMUX is set,
                -- then wezterm if $WEZTERM_PANE is set,
                -- otherwise false
                multiplexer_integration = "tmux",
            })

            -- recommended mappings
            -- resizing splits
            -- these keymaps will also accept a range,
            -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
            vim.keymap.set("n", "<A-h>", splits.resize_left,       { desc = "Resize window left" })
            vim.keymap.set("n", "<A-j>", splits.resize_down,       { desc = "Resize window down" })
            vim.keymap.set("n", "<A-k>", splits.resize_up,         { desc = "Resize window up" })
            vim.keymap.set("n", "<A-l>", splits.resize_right,      { desc = "Resize window right" })
            -- moving between splits
            vim.keymap.set("n", "<C-h>", splits.move_cursor_left,  { desc = "Move left one window" })
            vim.keymap.set("n", "<C-j>", splits.move_cursor_down,  { desc = "Move down one window" })
            vim.keymap.set("n", "<C-k>", splits.move_cursor_up,    { desc = "Move up one window" })
            vim.keymap.set("n", "<C-l>", splits.move_cursor_right, { desc = "Move right one window" })
        end,
    },
}
