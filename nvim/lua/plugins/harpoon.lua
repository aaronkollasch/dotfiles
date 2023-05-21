return {
    -- 'ThePrimeagen/harpoon',
    "aaronkollasch/harpoon",
    dev = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    -- stylua: ignore
    keys = {
        { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "[A]dd to Harpoon" },
        { "<leader><C-s>", function()
            require("telescope").extensions.harpoon.marks(require("telescope.themes").get_dropdown({}))
        end, desc = "Find harpoon files" },
        { "<C-s>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon menu" },
        { "<C-n>", function() require("harpoon.ui").nav_file(1) end, desc = "Goto Harpoon file 1" },
        { "<C-,>", function() require("harpoon.ui").nav_file(2) end, desc = "Goto Harpoon file 2" },
        { "<C-.>", function() require("harpoon.ui").nav_file(3) end, desc = "Goto Harpoon file 3" },
        { "<C-/>", function() require("harpoon.ui").nav_file(4) end, desc = "Goto Harpoon file 4" },
    },
    config = function()
        require("harpoon").setup({
            global_settings = {
                ["show_file_keymaps"] = true,
                ["file_keymaps"] = { "n", ",", ".", "/" },
                -- ["file_keymaps"] = { "h", "t", "n", "s" },
            },
        })
    end,
}
