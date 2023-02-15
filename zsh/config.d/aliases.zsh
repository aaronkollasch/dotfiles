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

if command -v exa &>/dev/null; then
    alias l="exa"
    alias ls="exa"
    alias la="exa -a"
    alias ll="exa -al --git --icons"
    alias lla="exa -al --git --icons"
    alias lll="exa -abghHliS@ --git --icons --time-style=full-iso"
    alias lt="exa -T --level=2 --group-directories-first --git-ignore"
    alias lT="exa -T --level=4 --group-directories-first --git-ignore"
    alias lat="exa -Ta --level=2 --group-directories-first"
    alias llt="exa -lT --level=2 --group-directories-first --git-ignore"
    alias lllt="exa -abghHliS@T --git --icons --time-style=full-iso"
    alias t="exa -lT --no-permissions --no-user --no-time --icons --git-ignore --git --group-directories-first"
    export EXA_ICON_SPACING=2
else
    alias l='ls -GFh'
    alias ls='ls -GFh'
    alias la='ls -GFha'
    alias ll='ls -lhAG'
    alias lla='ls -alhAG'
    if [[ "$(uname -s)" == "Darwin" ]]; then
        alias lll='ls -lhAis@GT'
    else
        alias lll='ls -lhAis@G --full-time'
    fi
fi

alias zconf="vi ~/.zshrc"
alias zsource="source ~/.zshrc"
alias zhup="source ~/.zshrc"
alias ds="du -hs * | sort -h"
alias nohist="unsetopt history"
alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'
alias twork='tmux attach -t work'
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
