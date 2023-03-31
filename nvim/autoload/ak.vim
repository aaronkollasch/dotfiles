if !exists('*ak#save_and_exec')
  function! ak#save_and_exec() abort
    if &filetype == 'vim'
      :silent! write
      :source %
    elseif &filetype == 'lua'
      :silent! write
      :luafile %
    endif

    return
  endfunction
endif

" from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
if !exists('*ak#redir')
  function! ak#redir(cmd, rng, start, end)
      for win in range(1, winnr('$'))
          if getwinvar(win, 'scratch')
              execute win . 'windo close'
          endif
      endfor
      if a:cmd =~ '^!'
          let cmd = a:cmd =~' %'
              \ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
              \ : matchstr(a:cmd, '^!\zs.*')
          if a:rng == 0
              let output = systemlist(cmd)
          else
              let joined_lines = join(getline(a:start, a:end), '\n')
              let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
              let output = systemlist(cmd . " <<< $" . cleaned_lines)
          endif
      else
          redir => output
          execute a:cmd
          redir END
          let output = split(output, "\n")
      endif
      vnew
      let w:scratch = 1
      setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
      call setline(1, output)
  endfunction
endif
