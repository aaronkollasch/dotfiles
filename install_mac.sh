#!/bin/bash

# add homebrew to path if not present
[[ :$PATH: == *:/opt/homebrew/bin:* ]] || { echo "Adding /opt/homebrew/bin to PATH"; export PATH=/opt/homebrew/bin:$PATH; }

command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="$HOME" "$SCRIPT_DIR")"
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

bash install_common.sh || retval=$?

source bash/functions.sh || retval=$?

# disable terminal message of the day
touch "$HOME"/.hushlogin

install_link "$SCRIPT_DIR"/bash/bashrc "$HOME"/.bashrc || retval=$?
install_link "$SCRIPT_DIR"/mac/inputrc "$HOME"/.inputrc || retval=$?
install_link "$SCRIPT_DIR"/pymol/pymolrc "$HOME"/.pymolrc || retval=$?
install_link "$SCRIPT_DIR"/git/gitconfig_mac "$HOME"/.gitconfig || retval=$?

create_dir "$HOME"/Library/Application\ Support/iTerm2/Scripts/AutoLaunch || retval=$?
install_link  "$HOME"/"$SCRIPT_DIR"/iterm2/Scripts/AutoLaunch/switch_automatic.py "$HOME"/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/switch_automatic.py "Installed iTerm2 profile switch script" || retval=$?

create_dir "$HOME"/.1password || retval=$?
install_link "$HOME"/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock "$HOME"/.1password/agent.sock "Installed 1password agent alias" || retval=$?

if [[ -e "$HOME/$SCRIPT_DIR/private" ]]; then
  bash private/install_mac.sh
fi

if [[ ! -e "$HOME"/.terminfo/ || $(find "$HOME"/.terminfo -name 'tmux-256color' | wc -c) -eq 0 ]]; then
  "$(brew --prefix ncurses)"/bin/infocmp tmux-256color > /tmp/tmux-256color.info || retval=$?
  # echo "	Smulx=\E[4\:%p1%dm," >> /tmp/tmux-256color.info
  # echo "	Setulc=\E[58\:2\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&%d\:%p1%{255}%&%d%;m," >> /tmp/tmux-256color.info
  tic -xe tmux-256color /tmp/tmux-256color.info && echo "Installed tmux-256color terminfo" || echo "Failed to install tmux-256color terminfo" || retval=$?
fi
if [[ ! -e "$HOME"/.terminfo/ || $(find "$HOME"/.terminfo -name 'wezterm' | wc -c) -eq 0 ]]; then
  tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo || retval=$?
  tic -xe wezterm "$tempfile" && echo "Installed wezterm terminfo" || echo "Failed to install wezterm terminfo" || retval=$?
  rm "$tempfile"
fi

if [[ ! -e "$HOME"/.iterm2_shell_integration.zsh ]]; then
  echo "Installing iterm2 integration"
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash || retval=$?
fi

create_dir "$HOME"/Library/Application\ Support/VSCodium/User/
install_link "$HOME"/.dotfiles/vscode/keybindings.json "$HOME"/Library/Application\ Support/VSCodium/User/keybindings.json
install_link "$HOME"/.dotfiles/vscode/settings.json "$HOME"/Library/Application\ Support/VSCodium/User/settings.json
command -v codium &>/dev/null && { ./vscode/install.sh || retval=$?; }

exit "${retval:-0}"
