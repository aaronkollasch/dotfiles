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

install_link ../"$SCRIPT_DIR"/mac/powermetrics_parse.py "$HOME"/bin/powermetrics-parse || retval=$?

create_dir "$HOME"/Library/LaunchAgents || retval=$?
install_copy "$HOME"/"$SCRIPT_DIR"/mac/LaunchAgents/user/com.jitouch.Jitouch.plist "$HOME"/Library/LaunchAgents/com.jitouch.Jitouch.plist "Installed Jitouch LaunchAgent" || retval=$?

create_dir "$HOME"/Library/Application\ Support/iTerm2/Scripts/AutoLaunch || retval=$?
install_link  "$HOME"/"$SCRIPT_DIR"/iterm2/Scripts/AutoLaunch/switch_automatic.py "$HOME"/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/switch_automatic.py "Installed iTerm2 profile switch script" || retval=$?

create_dir "$HOME"/.1password || retval=$?
install_link "$HOME"/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock "$HOME"/.1password/agent.sock "Installed 1password agent alias" || retval=$?

create_dir "$HOME"/Library/Containers/com.barebones.bbedit/Data/Library/Preferences || retval=$?
install_copy "$HOME/$SCRIPT_DIR"/mac/Application\ Support/BBEdit/Setup/BBEdit\ Preferences\ Sync.plist "$HOME"/Library/Containers/com.barebones.bbedit/Data/Library/Preferences/com.barebones.bbedit.plist "Installed BBEdit preferences" && defaults read com.barebones.bbedit >/dev/null || retval=$?
install_link "$HOME/$SCRIPT_DIR"/mac/Application\ Support/BBEdit "$HOME"/Library/Application\ Support/BBEdit "Installed BBEdit support folder" || retval=$?

install_copy "$HOME/$SCRIPT_DIR"/mac/Preferences/com.surteesstudios.Bartender.plist "$HOME"/Library/Preferences/com.surteesstudios.Bartender.plist "Installed Bartender preferences" && defaults read com.surteesstudios.Bartender >/dev/null || retval=$?
install_link "$HOME/$SCRIPT_DIR"/mac/Application\ Support/Bartender "$HOME"/Library/Application\ Support/Bartender "Installed Bartender application support folder" || retval=$?

install_copy "$HOME/$SCRIPT_DIR"/mac/Preferences/com.commandqapp.CommandQ.plist "$HOME"/Library/Preferences/com.commandqapp.CommandQ.plist "Installed CommandQ preferences" && defaults read com.commandqapp.CommandQ >/dev/null || retval=$?

install_copy "$HOME/$SCRIPT_DIR"/mac/Preferences/com.runningwithcrayons.Alfred.plist "$HOME"/Library/Preferences/com.runningwithcrayons.Alfred.plist "Installed Alfred plist" && defaults read com.runningwithcrayons.Alfred >/dev/null || retval=$?
install_copy "$HOME/$SCRIPT_DIR"/mac/Preferences/com.runningwithcrayons.Alfred-Preferences.plist "$HOME"/Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist "Installed Alfred-Preferences plist" && defaults read com.runningwithcrayons.Alfred-Preferences >/dev/null || retval=$?

install_copy "$HOME/$SCRIPT_DIR"/mac/Preferences/com.jitouch.Jitouch.plist "$HOME"/Library/Preferences/com.jitouch.Jitouch.plist "Installed Jitouch preferences" && defaults read com.jitouch.Jitouch >/dev/null || retval=$?

if [[ ! -e "$HOME"/.terminfo/ || $(find "$HOME"/.terminfo -name 'tmux-256color' | wc -c) -eq 0 ]]; then
  "$(brew --prefix ncurses)"/bin/infocmp tmux-256color > /tmp/tmux-256color.info || retval=$?
  tic -xe tmux-256color /tmp/tmux-256color.info && echo "Installed tmux-256color terminfo" || echo "Failed to install tmux-256color terminfo" || retval=$?
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
