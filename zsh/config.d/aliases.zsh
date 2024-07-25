## Aliases
export LSCOLORS=ExFxBxDxCxegedabagacad
_ls_colors () {
    if [[ -z ${LS_COLORS+x} ]]; then
        if ! command -v vivid &>/dev/null; then
            return
        fi
        if [[ $COLORTERM == "truecolor" ]]; then
            local gen_path="$HOME/.config/vivid/generated-truecolor"
        else
            local gen_path="$HOME/.config/vivid/generated-8-bit"
        fi
        local theme_path="$HOME/.config/vivid/theme"
        if [[ ! -f "$gen_path" || "$theme_path" -nt "$gen_path" ]]; then
            local theme
            theme="$(cat "$theme_path" | grep -v '^#')" || theme="catppuccin-frappe"
            theme="${theme# *}"
            if [[ $COLORTERM == "truecolor" ]]; then
                vivid generate "$theme" > "$gen_path"
            else
                vivid -m 8-bit generate "$theme" > "$gen_path"
            fi
        fi
        cat "$gen_path"
    else
        printf "$LS_COLORS"
    fi
}
zstyle ':completion:*' list-colors ${(s.:.)$(_ls_colors)}

if command -v eza &>/dev/null; then
    alias l="eza"
    alias ls="eza"
    alias la="eza -a"
    alias ll="eza -al --git --icons=auto"
    alias lla="eza -al --git --icons=auto"
    alias lll="eza -abghHliS@ --git --icons=auto --time-style=full-iso"
    alias lt="eza -T --level=2 --group-directories-first --git-ignore"
    alias lT="eza -T --level=4 --group-directories-first --git-ignore"
    alias lat="eza -Ta --level=2 --group-directories-first"
    alias llt="eza -lT --level=2 --group-directories-first --git-ignore"
    alias lllt="eza -abghHliS@T --git --icons=auto --time-style=full-iso"
    alias t="eza -lT --no-permissions --no-user --no-time --icons=auto --git-ignore --git --group-directories-first"
    export EZA_ICON_SPACING=2
else
    alias l='ls -GFh --color=auto'
    alias ls='ls -GFh --color=auto'
    alias la='ls -GFha --color=auto'
    alias ll='ls -lhAG --color=auto'
    alias lla='ls -alhAG --color=auto'
    if [[ "$(uname -s)" == "Darwin" ]]; then
        alias lll='ls -lhAis@GT --color=auto'
    else
        alias lll='ls -lhAis@G --full-time --color=auto'
    fi
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias :w="cowsay 'You are not in vim anymore.'"
alias :q="cowsay 'You are not in vim anymore.'"
alias :wq="cowsay 'You are not in vim anymore.'"
alias :x="cowsay 'You are not in vim anymore.'"

alias zconf="vi ~/.zshrc"
alias zsource="source ~/.zshrc"
alias zhup="source ~/.zshrc"
alias ds="du -hs * | sort -h"
alias nohist="unsetopt history"
alias history_clear="history -p"
alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'
alias twork='tmux attach -t work'
command -v pstree &>/dev/null && alias pstree='pstree -g 2'
{ command -v sponge &>/dev/null && alias tacat=sponge; } || alias tacat='tac | tac'
{ command -v bat &>/dev/null && alias cat=bat; } || { command -v batcat &>/dev/null && alias cat=batcat && alias bat=batcat; }
local fd_prefix='LS_COLORS="$(_ls_colors)"'
alias fd &>/dev/null || { command -v fd &>/dev/null && alias fd="$fd_prefix fd"; } || { command -v fdfind &>/dev/null && alias fd="$fd_prefix fdfind"; }
if ( ! command -v wezterm &>/dev/null ) && command -v flatpak &>/dev/null && flatpak list --app | grep -q org.wezfurlong.wezterm; then
    wezterm() {
        flatpak run org.wezfurlong.wezterm "$@"
    }
fi
if command -v wezterm &>/dev/null; then
    if env | grep -q WEZTERM; then
        alias imgcat='wezterm imgcat'
        if infocmp wezterm &>/dev/null; then
            alias nvim='TERM=wezterm nvim'
        fi
    fi
fi
if command -v nvim &>/dev/null; then
    alias vi='nvim'
    export GIT_EDITOR=nvim
fi
if ! command -v rg &>/dev/null; then
    alias rg='grep -r --color=auto --exclude-dir={\.git,\.svn,node_modules,venv,\.env,\.tox}'
fi
command -v op &>/dev/null && source ~/.config/op/plugins.sh

source ~/.dotfiles/zsh/config.d/git.aliases.zsh
