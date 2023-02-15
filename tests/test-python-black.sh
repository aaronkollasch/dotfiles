#!/usr/bin/env bash
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
cd "$SCRIPT_DIR/.." || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

retval=0
exclude_filter=
output=

command -v black &>/dev/null || { echo "black command not found" >&2; exit 1; }

# find files to check, excluding submodules and certain folders
# shellcheck disable=SC2016
mapfile -t submodules < <(git submodule foreach --quiet 'echo "$name"')
submodules+=()  # specify additional excludes here
exclude_filter="($(IFS='|'; echo "${submodules[*]}"))"
# exclude_filter="$(printf %q "$exclude_filter")"
echo "Excluding files: $exclude_filter" >&2

# run black
set -euo pipefail
output="$(black --check --diff --extend-exclude "$exclude_filter" .)" || retval=$?

if [[ "$retval" -gt 0 ]]; then
  # diff-style output
  echo "$output"
fi

[[ "$retval" == 0 ]] || exit 1
