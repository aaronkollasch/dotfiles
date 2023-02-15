require("nvim-lightbulb").setup({
    -- LSP client names to ignore
    -- Example: {"lua_ls", "null-ls"}
    ignore = {
        "marksman",
    },
    autocmd = { enabled = true },
})
