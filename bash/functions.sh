#!/bin/bash

function install_copy() {
  if [ -f "$2" ]; then
    [[ "$(shasum "$2")" == "$(shasum "$1")" ]] || echo "Not copying file: $1 to $2"
    return
  elif [ -e "$2" ]; then
    echo "Moving existing file: $2 to $2.bak"
    mv "$2" "$2.bak";
  fi
  { { cp -p "$1" "$2" && echo "${3:-Installed file: $2}"; } || { local retval=$?; echo "Could not install copy: $2"; return "$retval"; }; }
}

function install_link() {
  if [ -L "$2" ]; then
    if [[ "$(readlink "$2")" == "$1" ]]; then
      return
    else
      echo "Removing existing link: $2 -> $(readlink "$2")"
      unlink "$2"
    fi
  elif [ -e "$2" ]; then
    echo "Moving existing file: $2 to $2.bak"
    mv "$2" "$2.bak";
  fi
  { ln -s "$1" "$2" && echo "${3:-"Installed link: $2 -> $1"}"; } || { local retval=$?; echo "Could not install link: $2"; return "$retval"; }
}

function create_dir() {
  if [ -d "$1" ]; then
    return
  elif [ -e "$1" ]; then
    echo "Moving existing file: $1 to $1.bak"
    mv "$1" "$1.bak";
  fi
  { mkdir -p "$1" && echo "${3:-Created directory: $1}"; } || { local retval=$?; echo "Could not create dir: $1"; return "$retval"; }
}
