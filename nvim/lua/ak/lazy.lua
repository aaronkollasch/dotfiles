local opts = require("ak.opts")

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    }
end
require("lazy").setup("plugins", lazyopts)
