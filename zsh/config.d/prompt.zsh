if command -v starship &>/dev/null; then
  # Starship init
  eval "$(starship init zsh)"
  # source "$HOME/.dotfiles/zsh/config.d/starship.zsh"
else
  autoload -Uz vcs_info
  precmd_vcs_info() { vcs_info }
  precmd_functions+=( precmd_vcs_info )
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' formats ' on %B%F{magenta}%b%f'
  zstyle ':vcs_info:git*' formats ' on %B%F{magenta}%b%f %F{red}%m%u%c%f'
  setopt prompt_subst
  PS1='
%B%F{green}%n@%m%f%b in %B%F{blue}%~%f%b${vcs_info_msg_0_}%b
> '
  function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
      vicmd)      PROMPT_CHAR='<' ;;
      viins|main) PROMPT_CHAR='>' ;;
      *)          PROMPT_CHAR='>' ;;
    esac
    PS1='
%B%F{green}%n@%m%f%b in %B%F{blue}%~%f%b${vcs_info_msg_0_}%b
${PROMPT_CHAR} '
    zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
fi
