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

if vim.fn.has("win32") then
    vim.opt.shada = "!,'200,<50,s10,h,rA:,rB:"
else
    vim.opt.shada = "!,'200,<50,s10,h"
end

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "▸ ", extends = ">", precedes = "<" }
vim.opt.fillchars:append { diff = "╱" }

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

vim.opt.splitkeep = "screen"

vim.opt.breakindent = true
vim.opt.breakindentopt = "list:-1"
vim.opt.showbreak = "↳ "

vim.opt.signcolumn = "yes"
if vim.version().major > 0 or vim.version().minor >= 9 then
    -- see https://www.reddit.com/r/neovim/comments/10j0vyf/finally_figured_out_a_statuscolumn_i_am_happy/
    vim.opt.numberwidth = 3
    -- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
end

vim.opt.updatetime = 50

vim.opt.wildmode = "longest:full,full"

vim.opt.complete = ".,w,b,u,t,i,kspell"

vim.opt.cmdheight = 0

vim.opt.shortmess:append({ I = true })
