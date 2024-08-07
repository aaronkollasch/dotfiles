return {
    -- "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    "aaronkollasch/telescope.nvim",
    dev = false,
    dependencies = {
        "nvim-lua/plenary.nvim",

        -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },

        -- Telescope add-ons
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "crispgm/telescope-heading.nvim" },
    },
    event = "VeryLazy",
    config = function()
        require("ak.telescope.setup")
    end,
}
