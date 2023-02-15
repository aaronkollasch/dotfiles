#!/bin/bash

command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="$HOME" "$SCRIPT_DIR")"
cd "$HOME/$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

extensions=()
while IFS= read -r line; do
  [[ -n $line ]] && extensions+=( "$line" )
done < "extensions.txt"

echo 'Installing vscode extensions:'
printf '%s ' "${extensions[@]}"; echo

if command -v codium &>/dev/null; then
  for extension in "${extensions[@]}"; do
    ( codium --install-extension "$extension" | grep -vE 'Installing extensions...|already installed'; exit "${PIPESTATUS[0]}" ) || retval=$?
  done
else
  echo "codium command not found"
fi

echo 'Done installing vscode extensions'
exit "${retval:-0}"
