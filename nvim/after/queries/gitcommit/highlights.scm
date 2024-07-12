; extends

((subject) @comment.warning
  (#vim-match? @comment.warning ".\{50,}")
  (#offset! @comment.warning 0 50 0 0))
