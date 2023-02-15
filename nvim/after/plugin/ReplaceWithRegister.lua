vim.keymap.del("n", "grr")
vim.keymap.del("x", "gr")
vim.cmd([[
  " replace with register
  nmap <Leader>p  <Plug>ReplaceWithRegisterOperator
  nmap <Leader>pp <Plug>ReplaceWithRegisterLine
  xmap <Leader>p  <Plug>ReplaceWithRegisterVisual

  " replace with system clipboard
  nmap <Leader>v  "+<Plug>ReplaceWithRegisterOperator
  nmap <Leader>vv "+<Plug>ReplaceWithRegisterLine
  xmap <Leader>v  "+<Plug>ReplaceWithRegisterVisual
]])
