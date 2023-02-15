set colorcolumn=73
highlight LineTooLong ctermbg=darkmagenta ctermfg=white
call matchadd('LineTooLong', '\%1l\%>50c', 100)
setlocal spell
