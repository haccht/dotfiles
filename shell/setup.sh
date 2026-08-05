#!/usr/bin/env bash

set -euo pipefail

has() {
  command -v "$1" >/dev/null 2>&1
}

install_git_prompt() {
  has curl || return

  mkdir -p "$HOME/.bash.d"
  curl -fsSL \
    https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh \
    -o "$HOME/.bash.d/git-prompt.sh"
}

install_fzf() {
  if has fzf || ! has git; then
    return
  fi

  if [[ ! -d $HOME/.fzf/.git ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  else
    git -C "$HOME/.fzf" pull --ff-only
  fi

  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
  mkdir -p "$HOME/bin"
  ln -sf "$HOME/.fzf/bin/fzf" "$HOME/bin/fzf"
}

install_vim_plugins() {
  has vim || return

  vim -es -u "$HOME/.vimrc" +PlugUpgrade +PlugInstall +PlugUpdate +qall
  vim -es -u "$HOME/.vimrc" +PlugClean! +qall || echo 'Safe exit'
}

install_git_prompt
install_fzf
install_vim_plugins
