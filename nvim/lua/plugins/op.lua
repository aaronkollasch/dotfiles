return {
    "mrjones2014/op.nvim",
    build = "make install",
    keys = {
        { "<leader>op", function() require("op").op_insert() end, desc = "[O]ne[P]assword" },
        -- { "<leader>op", function() require("op.sidebar").toggle end, desc = "[O]ne[P]assword" },
    },
    opts = {
        sidebar = {
            side = "left",
        },
        mappings = {
            ["q"] = function()
                require("op.sidebar").close()
            end,
        },
    },
}
