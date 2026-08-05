#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd -P)"

link_file() {
  local source=$1 target=$2

  mkdir -p "$(dirname "$target")"
  ln -sfv "$source" "$target"
}

mkdir -p "$HOME/bin" "$HOME/src" "$HOME/.config" "$HOME/.bash.d"

while read -r source target; do
  [[ -n $source ]] || continue
  link_file "$script_dir/$source" "$HOME/$target"
done <<'LINKS'
bash_profile .bash_profile
bashrc .bashrc
gitconfig .gitconfig
tmux.conf .tmux.conf
gemrc .gemrc
irbrc .irbrc
vimrc .vimrc
config/ghostty/config .config/ghostty/config
LINKS

for source in "$script_dir"/bash.d/*; do
  [[ -f $source ]] || continue
  link_file "$source" "$HOME/.bash.d/$(basename "$source")"
done
