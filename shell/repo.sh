#!/usr/bin/env bash

set -euo pipefail

has() {
  command -v "$1" >/dev/null 2>&1
}

clone_or_update() {
  local repo=$1 directory=$2

  if [[ -d $directory/.git ]]; then
    git -C "$directory" pull --ff-only
  else
    git clone "$repo" "$directory"
  fi
}

has git || exit 0

clone_or_update https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
clone_or_update https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
