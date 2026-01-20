# modify WORDCHARS for forward-word and backward-word commands in zshall
# remove / to treat filepaths as multiple words
WORDCHARS=${WORDCHARS/\/}

#Command history configuration

if [ -z "$HISTFILE" ]; then
    export HISTFILE="$HOME"/.zsh_history
fi

export HISTSIZE=1000000
export SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS #ignore duplicates when searching
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS # removes blank lines from history
setopt hist_verify
setopt inc_append_history # adds commands as they are typed, not at shell exit
# setopt share_history # share command history data
setopt nosharehistory
setopt NO_CASE_GLOB
setopt CORRECT
unsetopt CORRECT_ALL  # Don't correct arguments
setopt interactive_comments # allow comments in interactive shells (needed for zsh-autocomplete)

# Bash-like navigation
autoload -U select-word-style
select-word-style bash

# vim mode
bindkey -v
unsetopt BEEP
bindkey -M viins '^[^?' backward-kill-word # alt-backspace to delete word
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^[b' backward-word       # alt-left
bindkey -M viins '^[f' forward-word        # alt-right
bindkey -M viins '^[[1;2D' backward-word   # shift-left
bindkey -M viins '^[[1;2C' forward-word    # shift-right
bindkey -M viins '^D' delete-char          # delete forward char
bindkey -M viins '^[[3~' delete-char       # delete forward char in wezterm
bindkey -M viins '^[d' kill-word           # alt-delete to delete forward word
bindkey -M viins '^[[3;3~' kill-word       # alt-delete to delete forward word in wezterm
bindkey -M vicmd '^?' backward-delete-char # can use backspace from vicmd mode
bindkey -M viins '^xh' _complete_help
bindkey -M viins '^x^h' _complete_help
bindkey -M viins '^x?' _complete_debug

# vim edit command
if command -v nvim &>/dev/null; then
    EDITOR=nvim
elif command -v vim &>/dev/null; then
    EDITOR=vim
elif command -v vi &>/dev/null; then
    EDITOR=vi
fi
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# key timeout
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    # 100ms for key sequences
    KEYTIMEOUT=10
else
    # 10ms for key sequences
    KEYTIMEOUT=1
fi
