export STARSHIP_CONFIG="$HOME"/.dotfiles/starship/starship-plain.toml
export BAT_THEME=OneHalfDark
export DELTA_FEATURES=+darkmode
export LC_RETRO=yes
bindkey -M viins '\e[1;3D' backward-word
bindkey -M viins '\e[1;3C' forward-word
if command -v eza &>/dev/null; then
    alias eza="eza --icons=never"
fi
