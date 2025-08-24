# fzf integration
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"
if [ -d /usr/share/doc/fzf/examples ]; then
  if [[ $- == *i* ]]; then
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
elif [ -d /opt/homebrew/opt/fzf/shell ]; then
  if [[ $- == *i* ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  fi
  source /opt/homebrew/opt/fzf/shell/completion.zsh
elif command -v fzf &>/dev/null; then
  if [[ $- == *i* ]]; then
    source ~/.dotfiles/zsh/repos/fzf/shell/key-bindings.zsh
  fi
  source ~/.dotfiles/zsh/repos/fzf/shell/completion.zsh
fi
[[ -v functions[fzf-history-widget] ]] && bindkey -M viins '^R' fzf-history-widget
[[ -v functions[fzf-history-widget] ]] && bindkey -M vicmd '^R' redo

# auto-completion
fpath=(~/.dotfiles/zsh/functions $fpath)
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' fzf-completion yes
zstyle ':autocomplete:*' min-delay 0.1
zstyle -e ':autocomplete:*:*' list-lines 'reply=( ${$(( LINES * 0.5 ))//%.*/} )'
source ~/.dotfiles/zsh/repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/.dotfiles/zsh/repos/fzf-tab/fzf-tab.plugin.zsh

# zsh-autocomplete keys
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/.zshrc

# use arrows to navigate history
bindkey '\e[A' up-line-or-history
bindkey '\eOA' up-line-or-history
bindkey -M viins '\e[A' up-line-or-history
bindkey -M viins '\eOA' up-line-or-history
bindkey '\e[B' down-line-or-history
bindkey '\eOB' down-line-or-history
bindkey -M viins '\e[B' down-line-or-history
bindkey -M viins '\eOB' down-line-or-history

# enter to immediately accept line
bindkey -M menuselect '\r' .accept-line

# vim navigation in menuselect
bindkey -M menuselect '^H' backward-char
bindkey -M menuselect '^J' down-line-or-history
bindkey -M menuselect '^K' up-line-or-history
bindkey -M menuselect '^L' forward-char
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char

# # down arrow opens completion in vicmd mode
# vi-down-line-or-select () {
#   if [[ $#BUFFER == 0 ]]; then
#     # BUFFER="ls "
#     # CURSOR=3
#   else
#     zle down-line-or-select -K vicmd -w
#   fi
# }
# zle -N vi-down-line-or-select
# bindkey '^[[B' vi-down-line-or-select
# bindkey -M viins '^[[B' vi-down-line-or-select

# # tab opens completion in vicmd mode
# # see https://github.com/marlonrichert/zsh-autocomplete/pull/506
# vi-menu-select () {
#   # fix tab completion on empty line https://unix.stackexchange.com/a/32426
#   # if [[ $#BUFFER == 0 ]]; then
#   #   BUFFER="ls "
#   #   CURSOR=3
#   # else
#   # handle two-line starship prompt
#   # typeset -g STARSHIP_RESET_PROMPT_NEWLINES=0
#   zle menu-select # -K vicmd
#   # fi
# }
# zle -N vi-menu-select
# bindkey '\t' vi-menu-select
# bindkey -M viins '\t' vi-menu-select
# bindkey -M vicmd '\t' vi-menu-select

# first tab enters menu-select
# shift-tab enters menu-select at last item
_reverse-menu-select () {
  zle menu-select
}
zle -N reverse-menu-select _reverse-menu-select
bindkey '\t' menu-select "$terminfo[kcbt]" reverse-menu-select
bindkey -M viins '\t' menu-select "$terminfo[kcbt]" reverse-menu-select
bindkey -M vicmd '\t' menu-select "$terminfo[kcbt]" reverse-menu-select
bindkey -M menuselect '\t' menu-select "$terminfo[kcbt]" reverse-menu-complete

# ctrl-f for fzf-tab completion
zstyle ":fzf-tab:*" default-color ""
my-fzf-tab-complete () {
  functions[compadd]=$functions[-ftb-compadd]
  zle fzf-tab-complete
}
zle -N my-fzf-tab-complete
bindkey '^F' my-fzf-tab-complete
bindkey -M viins '^F' my-fzf-tab-complete
bindkey -M vicmd '^F' my-fzf-tab-complete
bindkey -M menuselect '^F' send-break

# escape to exit completion
bindkey -M menuselect '\e' accept-line

# uncomment if skipping zsh-autocomplete
# autoload -U compinit && compinit

# op init
if command -v op &>/dev/null; then
  _op () {
    source ~/.dotfiles/zsh/functions/_op
    # eval "_op() { $(op completion zsh) }"
    _op "$@"
  }
  compdef _op op
fi

# just init
if command -v just &>/dev/null && ! command -v _just &>/dev/null; then
  _just () {
    eval "_just_cli() { $(just --completions zsh) }"
    _just_cli "$@"
  }
  compdef _just just
fi

# zoxide init
if command -v zoxide &>/dev/null; then
  # eval "$(zoxide init zsh --cmd j)"
  source ~/.dotfiles/zsh/config.d/zoxide.zsh
  alias cd="j"
  alias jj="j -"
else
  autoload -Uz cdr
  alias j="cd"
  alias jj="cd -"
fi

# wezterm init
if command -v wezterm &>/dev/null && ! command -v _wezterm &>/dev/null; then
  _wezterm () {
    eval "_wezterm_cli() { $(wezterm shell-completion --shell zsh) }"
    _wezterm_cli "$@"
  }
  compdef _wezterm wezterm
fi

# bash completions fallback init
export ZSH_BASH_COMPLETIONS_FALLBACK_BLACKLIST=(python python3 pydoc3)
source ~/.dotfiles/zsh/repos/zsh-bash-completions-fallback/zsh-bash-completions-fallback.plugin.zsh

# dvc init
if command -v dvc &>/dev/null && ! command -v _dvc &>/dev/null; then
  _dvc () {
    eval "_dvc() { $(dvc completion -s zsh) }"
    _dvc "$@"
  }
  compdef _dvc dvc
fi

# aws init
if command -v aws_completer &>/dev/null; then
  complete -C aws_completer aws
fi
