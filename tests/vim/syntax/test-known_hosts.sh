#!/bin/bash
set -euxo pipefail
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
VSL="$SCRIPT_DIR/vim-syntax-legend/vim-syntax-legend"

# test known_hosts syntax
example_file="$SCRIPT_DIR/known_hosts"
original_file="$SCRIPT_DIR/known_hosts.vsl"
changed_file="$SCRIPT_DIR/known_hosts_changed.vsl"
"$VSL" -t known_hosts -i "$example_file" -o "$changed_file" -p "$original_file"
retval=$?

# format output
if command -v delta &>/dev/null && [[ -t 1 ]]; then
  # diff with asymmetric context: -A0 -B1
  diff -U1 "$original_file" "$changed_file" |
    tac |
    awk '/^[-+]/ {if (n < 2) n=2} /^@/ {if (n < 1) n=1}  n-- > 0; n == 0 {}' |
    tac |
    delta --line-numbers --hunk-header-style="omit" --paging="never" \
    || retval="${PIPESTATUS[0]}"
else
  # diff with asymmetric context: -A0 -B1
  diff -U1 "$original_file" "$changed_file" |
    tac |
    awk '/^[-+]/ {if (n < 2) n=2} /^@/ {if (n < 1) n=1}  n-- > 0; n == 0 {}' |
    tac || retval="${PIPESTATUS[0]}"
fi
[[ "$retval" == 0 ]] || exit "$retval"
