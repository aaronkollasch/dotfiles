# iTerm2 integration
if [[ $LC_TERMINAL == "iTerm2" && -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
    source ~/.iterm2_shell_integration.zsh
fi
if env | grep -q WEZTERM; then
    source ~/.dotfiles/zsh/config.d/wezterm.sh
fi
if [[ "$LC_TERMINAL" == "cool-retro-term" ]]; then
    source "$HOME/.dotfiles/zsh/config.d/retro.zsh"
fi
