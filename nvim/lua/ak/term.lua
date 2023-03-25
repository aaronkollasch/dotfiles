vim.cmd([[
" use term gui colors
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
" enable italic fonts https://github.com/sainnhe/gruvbox-material/issues/5#issuecomment-729586348
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
" disable bold in cool-retro-term
if $LC_TERMINAL == "cool-retro-term"
  set t_md=
else
  " enable undercurl
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
endif
" allow correct indentation when pasting in tmux https://vi.stackexchange.com/a/28284
if &term =~ "screen" || &term =~ "tmux"
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif
]])
