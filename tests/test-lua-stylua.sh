#!/usr/bin/env bash
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
cd "$SCRIPT_DIR/.." || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

retval=0
output=

command -v stylua &>/dev/null || { echo "stylua command not found" >&2; exit 1; }

# run stylua
set -euo pipefail
output="$(stylua --check --output-format json nvim/ wezterm/)" || retval=$?

if [[ "$retval" -gt 0 ]]; then
  # diff-style output
  while read -r json; do
    path="$(jq '.file' <<< "$json")"
    echo "--- $path"
    echo "+++ $path"
    while read -r mismatch; do
      # echo $mismatch
      original_start=$(jq '.original_start_line' <<< "$mismatch")
      original_length=$(jq '.original_end_line - .original_start_line + 1' <<< "$mismatch")
      expected_start=$(jq '.expected_start_line' <<< "$mismatch")
      expected_length=$(jq '.expected_end_line - .expected_start_line + 1' <<< "$mismatch")
      echo "@@ -$original_start,$original_length +$expected_start,$expected_length @@"
      original="$(jq -r '.original' <<< "$mismatch")"
      expected="$(jq -r '.expected' <<< "$mismatch")"
      diff -u <(echo -e "$original") <(echo -e "$expected") | tail -n +4 || true
    done <<< "$(jq -cr '.mismatches[]' <<< "$json")"
  done <<< "$output"
fi

[[ "$retval" == 0 ]] || exit 1
