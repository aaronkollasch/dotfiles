#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$(realpath --relative-to="$HOME" "$SCRIPT_DIR")"
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

bash install_common.sh || retval=$?

source bash/functions.sh || retval=$?

install_link "$SCRIPT_DIR"/bash/bashrc_linux "$HOME"/.bashrc || retval=$?
install_link "$SCRIPT_DIR"/git/gitconfig_server "$HOME"/.gitconfig || retval=$?
install_link ../../"$SCRIPT_DIR"/nvim/lazy-lock-linux.json "$HOME"/.config/nvim/lazy-lock.json || retval=$?

exit "${retval:-0}"
