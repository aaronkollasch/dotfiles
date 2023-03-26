export STARSHIP_CONFIG="$HOME"/.dotfiles/starship/starship-plain.toml
export BAT_THEME=OneHalfDark
export DELTA_FEATURES=+darkmode
export LC_RETRO=yes
bindkey -M viins '\e[1;3D' backward-word
bindkey -M viins '\e[1;3C' forward-word
if command -v exa &>/dev/null; then
    alias exa="exa --no-icons"
fi
