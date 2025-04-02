#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$(realpath --relative-to="$HOME" "$SCRIPT_DIR")" || { echo "GNU realpath not present" >&2; exit 1; }
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

bash install_common.sh || retval=$?

source bash/functions.sh || retval=$?

install_link "$SCRIPT_DIR"/bash/bashrc_linux "$HOME"/.bashrc || retval=$?
install_link "$SCRIPT_DIR"/git/gitconfig_server "$HOME"/.gitconfig || retval=$?

exit "${retval:-0}"
