#!/bin/bash

usage() {
  SELF="${0##*/}"
  echo -e "USAGE
  $SELF [--dst <path>] [--help]

  Copy .vimrc and the .vim directory to the given destination directory
  (or ~ if not specified).

  --dst
    destination directory (defaults to user home ~ if none specified)

  -h, --help
    print this message and exit"

  exit 1
}

DST_DIR="$HOME"
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
elif [[ -n "$1" ]]; then
  DST_DIR="$(readlink -f "$1")"
fi

# Where this script lives.
SCRIPT_DIR=$(readlink -f $(dirname "$0"))

REPO_DIR=$(readlink -f "$SCRIPT_DIR/..")

git submodule update --init --recursive
git submodule update --recursive --remote

cd "$REPO_DIR"
cp vim/.vimrc "$DST_DIR"
cp -r vim/.vim "$DST_DIR"
