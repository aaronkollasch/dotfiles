#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="$HOME" "$SCRIPT_DIR")" || { echo "GNU realpath not present" >&2; exit 1; }
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

bash install_common.sh || retval=$?

source bash/functions.sh || retval=$?

install_link "$SCRIPT_DIR"/bash/bashrc_linux "$HOME"/.bashrc || retval=$?
install_link "$SCRIPT_DIR"/git/gitconfig_linux "$HOME"/.gitconfig || retval=$?
[ -e "$HOME"/.var/app/org.wezfurlong.wezterm/config ] && [ ! -e "$HOME"/.var/app/org.wezfurlong.wezterm/config/wezterm ] && install_link "$HOME/$SCRIPT_DIR"/wezterm "$HOME"/.var/app/org.wezfurlong.wezterm/config/wezterm "Installed flatpak wezterm config" || echo "Did not install flatpak wezterm config"
if ! infocmp wezterm 2>/dev/null | grep -q kEND; then
  tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo || retval=$?
  tic -xe wezterm "$tempfile" && echo "Installed wezterm terminfo" || echo "Failed to install wezterm terminfo" || retval=$?
  rm "$tempfile"
fi

# system vscodium
create_dir "$HOME"/.config/VSCodium/User/
install_link "$HOME"/.dotfiles/vscode/keybindings.json "$HOME"/.config/VSCodium/User/keybindings.json
install_link "$HOME"/.dotfiles/vscode/settings.json "$HOME"/.config/VSCodium/User/settings.json
# flatpak vscodium
create_dir "$HOME"/.var/app/com.vscodium.codium/config/VSCodium/User/
install_link "$HOME"/.dotfiles/vscode/keybindings.json "$HOME"/.var/app/com.vscodium.codium/config/VSCodium/User/keybindings.json
install_link "$HOME"/.dotfiles/vscode/settings.json "$HOME"/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json
command -v codium &>/dev/null && { ./vscode/install.sh || retval=$?; }

exit "${retval:-0}"
