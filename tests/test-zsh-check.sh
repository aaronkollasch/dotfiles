#!/usr/bin/env bash
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
cd "$SCRIPT_DIR/.." || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

retval=0
files=()
file=

command -v zsh &>/dev/null || { echo "zsh command not found" >&2; exit 1; }
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
printf "%s\n" "${submodules[@]}" >&2
mapfile -t -O "${#files}" files < <("$FDFIND" "." "." "${submodules[@]}" --type f --exec awk 'FNR == 1 && ( FILENAME ~ /.*(\.zsh|zshenv|zshrc|zprofile|zlogin|zlogout)$/ || /^#(!.*[\/ ]zsh|compdef|autoload)/){print FILENAME}' | sort)
set +x
printf "%s\n" "${files[@]}" >&2

# spot check for expected files in list to check
declare -A files_map
for key in "${!files[@]}"; do file="${files[$key]/#\.\//}"; files_map["$file"]="$key"; done
declare -a examples=(zsh/functions/_b3sum-recursive zsh/zshrc zsh/config.d/options.zsh)
for file in "${examples[@]}"; do
  [[ -n "${files_map[$file]}" ]] || { printf '%s not found\n' "$file"; retval=1; }
done
[[ "$retval" == 0 ]] || exit 1

# run check and format output
# https://github.com/koalaman/shellcheck/issues/809
has_error=0
for file in "${files[@]}"; do
  retval=0
  output="$(zsh -n "$file" 2>&1)" || retval=$?
  if [[ "$retval" -gt 0 ]]; then
    has_error="$retval"
    echo "FAIL: zsh -n $file" >&2
    echo "$output" >&2
    # echo "$output"
    echo "--- $file"
    echo "+++ $file"
    while read -r line; do
      if [[ "$line" =~ ^(.*):([[:digit:]]+):[[:space:]]+(.*)$ ]]; then
        file="${BASH_REMATCH[1]}"
        ln="${BASH_REMATCH[2]}"
        msg="${BASH_REMATCH[3]}"
        lastline=$((-CONTEXT_LEN))
        if [[ "$ln" -gt $((lastline + CONTEXT_LEN)) ]]; then
          echo "@@ +$ln,1 @@"
        fi
        echo "$ln: $msg"
        lastline=$((ln))
      else
        echo "ERROR: line not recognized: $line" >&2
      fi
    done <<< "$output"
  fi
done
echo "Checked ${#files} files" >&2
[[ "$has_error" == 0 ]] || exit 1
