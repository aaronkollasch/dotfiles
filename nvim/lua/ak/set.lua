vim.cmd([[ syntax enable ]])

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.synmaxcol = 10000

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "▸ " }

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.wildmode = "longest:full,full"

vim.opt.complete = ".,w,b,u,t,i,kspell"
