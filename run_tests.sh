#!/usr/bin/env bash
set -Eeuo pipefail

# ANSI color variables
if [[ -t 1 ]]; then
  RED=$'\e[31m'
  GREEN=$'\e[32m'
  BLUE=$'\e[34m'
  RESET=$'\e[0m'
else
  RED=
  GREEN=
  BLUE=
  RESET=
fi

# change directory
command -v grealpath &>/dev/null && REALPATH=grealpath || REALPATH=realpath
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SCRIPT_DIR="$($REALPATH --relative-to="." "$SCRIPT_DIR")"
cd "$SCRIPT_DIR" || { echo "Could not change directories: $SCRIPT_DIR" >&2; exit 1; }

# parse arguments
PARAMS=""
QUIET=
PARALLEL=
while (( "$#" )); do
  case "$1" in
    -p|--parallel)
      PARALLEL=yes
      shift 1
      ;;
    -q|--quiet)
      QUIET=yes
      shift 1
      ;;
    -h|--help)
      echo "./run_tests.sh [-p] [-q]" >&2
      exit 0
      ;;
    -*) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"
TESTDIR="${1:-tests}"

# set variables
num_passed=0
num_failed=0
failed=()
outputs=()
output=
errmsg=
retval=
script=
scripts=()
i=0
title=
titles=()
fd=
fds=()
pid=
pids=()

# catch stdout and stderr from the same call
# adapted from: https://stackoverflow.com/a/59592881
# see: https://stackoverflow.com/questions/11027679/capture-stdout-and-stderr-into-different-variables
# see also: https://unix.stackexchange.com/questions/430161/redirect-stderr-and-stdout-to-different-variables-without-temporary-files
catch_subproc() {
  # run commands $@ and output as NUL-separated string:
  # order: stdout, stderr, retval
  (printf '\0%s\0%d\0' "$( ( ( ({ "${@}"; echo "${?}" 1>&3-; } | tr -d '\0' 1>&4-) 4>&2- 2>&1- | tr -d '\0' 1>&4-) 3>&1- | exit "$(cat)") 4>&1-)" "${?}" 1>&2) 2>&1
}
read_catch() {
  # read NUL-separated stdin parts and save to variables $1, $2, $3
  {
    IFS=$'\n' read -r -d '' "${1}";
    IFS=$'\n' read -r -d '' "${2}";
    IFS=$'\n' read -r -d '' "${3}";
  }
}
catch() {
  # catch stdout and stderr from the same call
  # SYNTAX:
  #   catch STDOUT_VARIABLE STDERR_VARIABLE RETVAL_VARIABLE COMMAND [ARG1[ ARG2[ ...[ ARGN]]]]
  read_catch "$1" "$2" "$3" < <(shift 3; catch_subproc "$@")
}

process_output_errmsg() {
  # process $output, $errmsg, and $retval and print appropriate messages
  local title="$1"
  if [[ $retval -gt 0 ]]; then
    if [[ "$QUIET" == yes ]]; then
      printf "<FAIL:%s>" "$title" >&2
    else
      echo "FAIL: $title" >&2
      echo "$errmsg" >&2
      echo "" >&2
    fi
    ((++num_failed))
    failed+=("$title")
    outputs+=("$output")
  else
    if [[ "$QUIET" == yes ]]; then
      printf "." >&2
    else
      echo "PASS: $title" >&2
    fi
    ((++num_passed))
  fi
}

# find all test scripts
readarray -t scripts < <(find "$TESTDIR" -type f -name "test-*.sh" | sort)
printf "Running %d tests " "${#scripts[@]}" >&2
[[ "$QUIET" != yes ]] && echo >&2

# run each test script
for script in "${scripts[@]}"; do
  if [[ -z $script ]]; then
    continue
  fi
  title="${script::-3}"       # remove .sh suffix
  title="${title/\/test-/\/}" # remove test- name prefix
  title="${title##./}"        # remove ./ prefix
  title="${title##tests/}"    # remove tests/ prefix

  if [[ $PARALLEL == yes ]]; then
    # capture outputs of test with catch_subproc in background
    # see https://stackoverflow.com/a/68279121
    ((fd=50+i))
    eval "exec $fd< <({ catch_subproc bash \"$script\"; })"
    titles+=("$title")
    fds+=("$fd")
    pids+=($!)
    ((++i))
  else
    # capture test outputs and process them in foreground
    catch output errmsg retval bash "$script"
    process_output_errmsg "$title"
  fi
done

# process outputs in parallel mode
if [[ $PARALLEL == yes ]]; then
  # process tests live as they finish
  # https://stackoverflow.com/a/70670852
  while true; do
    for i in "${!pids[@]}"; do
      pid="${pids[$i]}"
      if ! ps -p "$pid" > /dev/null; then
        # if pid has stopped running, process outputs
        fd="${fds[$i]}"
        read_catch output errmsg retval <&"$fd"
        title="${titles[$i]}"
        process_output_errmsg "$title"

        # remove pid, fd, and title from array
        unset "pids[$i]"
        unset "fds[$i]"
        unset "titles[$i]"
      fi
    done
    if [ "${#pids[@]}" -eq 0 ]; then
        break
    fi
    sleep 0.1
  done
  # # wait for all tests to finish before processing
  # # readarray -t pids < <(jobs -rp)
  # wait "${pids[@]}"
  # i=0
  # for title in "${titles[@]}"; do
  #   fd="${fds[$i]}"
  #   read_catch output errmsg retval <&"$fd"
  #   process_output_errmsg "$title"
  #   ((++i))
  # done
fi

# print summary of results
if [[ "$QUIET" == yes ]]; then
  [[ $num_failed -eq 0 ]] && RED=
  echo "" >&2
  echo "Test results: ${BLUE}$((num_passed+num_failed))${RESET} tests run, ${GREEN}$((num_passed))${RESET} passed, ${RED}$((num_failed))${RESET} failed" >&2
else
  echo "" >&2
  echo "Results:" >&2
  echo "========" >&2
  echo "" >&2
  [[ $num_failed -gt 0 ]] && echo "  Failed: ${RED}$((num_failed))${RESET}" >&2
  echo "  Passed: ${GREEN}$((num_passed))${RESET}" >&2
  echo "  Total : ${BLUE}$((num_passed+num_failed))${RESET}" >&2
  echo "" >&2
  if [[ $num_failed -gt 0 ]]; then
    echo "Failed:" >&2
    echo "=======" >&2
    echo "" >&2
    for title in "${failed[@]}"; do
      echo "  $title" >&2
    done
    echo "" >&2
    output="$(for output in "${outputs[@]}"; do echo "$output"; done)"
    if [[ -t 1 ]]; then
      echo "$output" | delta --line-numbers --paging="never"
    else
      echo "$output"
    fi
  fi
fi
[[ $num_failed -eq 0 ]] || exit 1
