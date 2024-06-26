local opts = require("ak.opts")

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local lazyopts = {
    dev = {
        path = "~/plugins",
        fallback = true,
    },
    ui = {},
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "matchit",
                "matchparen",
            },
        },
    },
}
if not opts.icons_enabled then
    lazyopts.ui.icons = {
        cmd = "ː",
        config = "C",
        event = "√",
        ft = "⎡⎫",
        init = "⎆",
        import = "⎘",
        keys = "⌙",
        plugin = "◆",
        runtime = "𝙑",
        source = "</>",
        start = "▶︎",
        task = "T",
        lazy = "⋰ ",
        loaded = "●",
        not_loaded = "○",
        list = {
            "✶",
            "→",
            "●",
            "‒",
        },
    }
end
require("lazy").setup("plugins", lazyopts)
