#!/bin/bash

command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="$HOME" "$SCRIPT_DIR")"
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

source bash/functions.sh || retval=$?

install_link "$SCRIPT_DIR"/zsh/zlogout "$HOME"/.zlogout || retval=$?
install_link "$SCRIPT_DIR"/zsh/zshrc "$HOME"/.zshrc || retval=$?
install_link "$SCRIPT_DIR"/zsh/zprofile "$HOME"/.zprofile || retval=$?
install_link "$SCRIPT_DIR"/zsh/zshenv "$HOME"/.zshenv || retval=$?
install_link "$SCRIPT_DIR"/bash/bash_logout "$HOME"/.bash_logout || retval=$?

install_link "$SCRIPT_DIR"/vim/vimrc "$HOME"/.vimrc || retval=$?
install_link "$SCRIPT_DIR"/vim/vimrc "$HOME"/.ideavimrc || retval=$?
create_dir "$HOME"/.vim/undodir || retval=$?
[ -e "$HOME"/.vim/autoload/plug.vim ] || { curl -fLso "$HOME"/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo "Installed vim-plug" || retval=$?; }
find vim -mindepth 1 -maxdepth 1 -type d -print | while read -r dir; do install_link "../$SCRIPT_DIR/$dir" "$HOME/.$dir" || retval=$?; done

install_link ../../"$SCRIPT_DIR"/nvim/init.lua "$HOME"/.config/nvim/init.lua || retval=$?
find nvim -mindepth 1 -maxdepth 1 -type d -print | while read -r dir; do install_link "../../$SCRIPT_DIR/$dir" "$HOME/.config/$dir" || retval=$?; done

create_dir "$HOME"/.tmux || retval=$?
create_dir "$HOME"/.tmux/logs || retval=$?
create_dir "$HOME"/.tmux/resurrect || retval=$?
install_link "$SCRIPT_DIR"/tmux/tmux.conf "$HOME"/.tmux.conf || retval=$?
[ -e "$HOME"/.tmux/plugins/tpm ] || { git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm && echo "Installed tmux plugin manager" || retval=$?; }
( infocmp -x tmux-256color 2>&1 | head -n 10000 &>/dev/null; exit "${PIPESTATUS[0]}" ) || { echo "WARNING: tmux-256color terminfo not present"; }

create_dir "$HOME"/.config/git || retval=$?
install_link ../../"$SCRIPT_DIR"/git/config "$HOME"/.config/git/config || retval=$?
install_link "$SCRIPT_DIR"/git/git_template "$HOME"/.git_template || retval=$?
install_link "$SCRIPT_DIR"/git/gitignore "$HOME"/.gitignore || retval=$?

install_link "$SCRIPT_DIR"/less/lesskey "$HOME"/.lesskey || retval=$?
[ "$(less --version | sed -nE 's/.*less ([0-9]+).*/\1/p')" -ge 582 ] || [ "$HOME"/.less -nt "$HOME"/.lesskey ] || { lesskey && echo "Created ~/.less with lesskey" || retval=$?; }

install_link "$SCRIPT_DIR"/mambaforge/condarc "$HOME"/.condarc || retval=$?
install_link "$SCRIPT_DIR"/mambaforge/mambarc "$HOME"/.mambarc || retval=$?

create_dir "$HOME"/.matplotlib || retval=$?
install_link ../"$SCRIPT_DIR"/matplotlib/matplotlibrc "$HOME"/.matplotlib/matplotlibrc || retval=$?

# install bin files
create_dir "$HOME"/bin || retval=$?
find bin -maxdepth 1 -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec test -x {} \; -print | while read -r file; do install_link "../$SCRIPT_DIR/$file" "$HOME/$file" || retval=$?; done || retval=$?

create_dir "$HOME"/.config/bat || retval=$?
install_link ../../"$SCRIPT_DIR"/bat/config "$HOME"/.config/bat/config || retval=$?
install_link ../../"$SCRIPT_DIR"/bat/themes "$HOME"/.config/bat/themes || retval=$?
[ "$HOME"/.cache/bat/themes.bin -nt "$HOME/$SCRIPT_DIR"/bat/themes/sublime-darkula/dracula.tmTheme ] || { bat cache --build && echo "Created ~/.cache/bat/ with bat" || echo "Could not create bat cache"; }

create_dir "$HOME"/.config/vivid || retval=$?
install_link ../../"$SCRIPT_DIR"/vivid/theme "$HOME"/.config/vivid/theme || retval=$?

install_link ../"$SCRIPT_DIR"/starship/starship.toml "$HOME"/.config/starship.toml || retval=$?

create_dir "$HOME"/.ssh && chmod 700 "$HOME"/.ssh || retval=$?
if [[ -e "$HOME/$SCRIPT_DIR/private" ]]; then
  install_link ../"$SCRIPT_DIR"/private/ssh/config "$HOME"/.ssh/config || retval=$?
  install_link ../"$SCRIPT_DIR"/private/ssh/known_hosts "$HOME"/.ssh/known_hosts || retval=$?
  install_link ../"$SCRIPT_DIR"/private/ssh/known_hosts2 "$HOME"/.ssh/known_hosts2 || retval=$?
fi

install_link ../"$SCRIPT_DIR"/wezterm "$HOME"/.config/wezterm || retval=$?

install_link ../"$SCRIPT_DIR"/fish/config "$HOME"/.config/fish || retval=$?

create_dir "$HOME"/.config/op || retval=$?
install_link ../../"$SCRIPT_DIR"/op/plugins.sh "$HOME"/.config/op/plugins.sh || retval=$?

exit "${retval:-0}"
