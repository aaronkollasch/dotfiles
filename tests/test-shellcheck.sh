#!/usr/bin/env bash
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
cd "$SCRIPT_DIR/.." || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

CONTEXT_LEN=10
retval=0
files=()
file=

command -v shellcheck &>/dev/null || { echo "shellcheck command not found" >&2; exit 1; }
if command -v fd &>/dev/null; then
  FDFIND=fd
elif command -v fdfind &>/dev/null; then
  FDFIND=fdfind
else
  echo "fd command not found" >&2
  exit 1
fi

# find files to check, excluding submodules and certain folders
set -x
# shellcheck disable=SC2016
mapfile -t submodules < <(git submodule foreach --quiet 'echo "-E";echo "$name"')
submodules+=(-E "mac/alfred/Alfred.alfredpreferences" -E "mac/Application Support/Bartender")
mapfile -t -O "${#files}" files < <("$FDFIND" "." "." "${submodules[@]}" --type f --exec awk 'FNR == 1 && ( FILENAME ~ /.*(\.sh|\.bash|\.dash|\.ksh)$/ || /^(#!.*[\/ ](sh|bash|dash|ksh)|# shellcheck)/){print FILENAME}' | sort)
set +x

# spot check for expected files
declare -A files_map
for key in "${!files[@]}"; do file="${files[$key]/#\.\//}"; files_map["$file"]="$key"; done
declare -a examples=(
  bin/b3sum-recursive
  osx
  run_tests.sh
  install_common.sh
  tests/test-shellcheck.sh
  mac/install_deps
  ubuntu/save_apt.sh
  "mac/Application Support/BBEdit/Preview Filters/GitHubFlavoredMarkdown.sh"
)
for file in "${examples[@]}"; do
  [[ -n "${files_map[$file]}" ]] || { printf '%s not found\n' "$file"; retval=1; }
done
[[ "$retval" == 0 ]] || exit 1

# run shellcheck
set -euxo pipefail
output="$(shellcheck --format=gcc "${files[@]}")"$'\n' || retval=$?
output="${output}$(shellcheck --format=gcc --exclude=SC1090,SC1091,SC2154,SC2181 --shell bash bash/bash*)"$'\n' || retval=$?
set +x

# format output
if [[ "$retval" -gt 0 ]]; then
  # diff-style output
  lastline=$((-CONTEXT_LEN))
  lastfile=
  while read -r line; do
    if [[ "$line" =~ ^(.*):([[:digit:]]+):([[:digit:]]+):[[:space:]]+([a-zA-Z]+:.*)$ ]]; then
      file="${BASH_REMATCH[1]}"
      ln="${BASH_REMATCH[2]}"
      col="${BASH_REMATCH[3]}"
      msg="${BASH_REMATCH[4]}"
      if [[ "$file" != "$lastfile" ]]; then
        echo "FAIL: shellcheck $file" >&2
        lastline=$((-CONTEXT_LEN))
        lastfile="$file"
        echo "--- $file"
        echo "+++ $file"
      fi
      if [[ "$ln" -gt $((lastline + CONTEXT_LEN)) ]]; then
        echo "@@ +$ln,$col @@"
      fi
      echo "$ln:$col: $msg"
      lastline=$((ln))
    elif [[ -n "$line" ]]; then
      echo "ERROR: line not recognized: $line" >&2
    fi
  done <<< "$output"
fi

echo "Checked ${#files} files" >&2
[[ "$retval" == 0 ]] || exit 1
