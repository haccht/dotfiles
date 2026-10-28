#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
apt_updated=0

has() {
  command -v "$1" >/dev/null 2>&1
}

link_file() {
  local source=$1 target=$2
  mkdir -p "$(dirname "$target")"
  ln -sfv "$source" "$target"
}

clone_or_update() {
  local repo=$1 directory=$2
  if [[ -d $directory/.git ]]; then
    git -C "$directory" pull --ff-only
  else
    git clone "$repo" "$directory"
  fi
}

# ---------------------------------------------------------------------------
# Subcommand: init (directories & symlinks)
# ---------------------------------------------------------------------------
cmd_init() {
  echo "==> Initializing directories and symlinks..."
  mkdir -p "$HOME/bin" "$HOME/.local/bin" "$HOME/src" "$HOME/.config" "$HOME/.bash.d"

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

  # Clean up legacy numbered bash.d symlinks that were merged into bashrc
  local old_link
  for old_link in "$HOME"/.bash.d/[0-9]*.bash "$HOME/.bash.d/ssh-agent.sh" "$HOME/.bash.d/ssh-agent-sock.sh"; do
    if [[ -L $old_link ]]; then
      rm -fv "$old_link"
    fi
  done
}

# ---------------------------------------------------------------------------
# Subcommand: packages (OS packages & Go runtime)
# ---------------------------------------------------------------------------
is_installed() {
  local pkgname=$1
  local check_cmd=${2:-$1}

  if has "$check_cmd"; then
    return 0
  fi

  if [[ $OSTYPE == darwin* ]] && has brew; then
    brew list --versions "$pkgname" >/dev/null 2>&1 && return 0
  fi

  return 1
}

install_package() {
  local pkgname=$1
  local check_cmd=${2:-$1}

  if is_installed "$pkgname" "$check_cmd"; then
    return
  fi

  echo "Installing $pkgname..."
  if has apt-get; then
    if (( ! apt_updated )); then
      sudo env DEBIAN_FRONTEND=noninteractive apt-get update -y
      apt_updated=1
    fi
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkgname"
  elif has pacman; then
    sudo pacman -S --noconfirm "$pkgname"
  elif has dnf; then
    sudo dnf install -y "$pkgname"
  elif has yum; then
    sudo yum install -y "$pkgname"
  elif has brew; then
    brew install "$pkgname"
  else
    echo "No supported package manager found for $pkgname" >&2
    return 1
  fi
}

install_homebrew() {
  if [[ $OSTYPE != darwin* ]] || has brew; then
    return
  fi
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_xcode_tools() {
  if [[ $OSTYPE == darwin* ]] && ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
  fi
}

install_go_from_tarball() {
  if has go || [[ -x /usr/local/go/bin/go ]] || [[ $OSTYPE == darwin* ]]; then
    return
  fi

  echo "Installing Go from official tarball..."
  local goos goarch goversion
  goos=$(uname -s | tr '[:upper:]' '[:lower:]')
  goarch=$(uname -m)
  case $goarch in
    x86_64)        goarch=amd64 ;;
    aarch64|arm64) goarch=arm64 ;;
    *) echo "Unsupported Go architecture: $goarch" >&2; return 1 ;;
  esac

  goversion="$(curl -fsSL 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')"
  curl -fsSL "https://dl.google.com/go/${goversion}.${goos}-${goarch}.tar.gz" |
    sudo tar xz -C /usr/local
}

cmd_packages() {
  echo "==> Checking packages..."
  install_homebrew
  install_xcode_tools

  if [[ $OSTYPE == darwin* ]]; then
    install_package bash
    if [[ ! -r /opt/homebrew/etc/profile.d/bash_completion.sh && ! -r /usr/local/etc/profile.d/bash_completion.sh && ! -r /opt/homebrew/etc/bash_completion && ! -r /usr/local/etc/bash_completion ]]; then
      install_package bash-completion
    fi
    install_package go
    install_package ghq
  fi

  install_package git
  install_package vim
  install_package tmux
  if ! has bat && ! has batcat; then
    install_package bat
  fi
  install_package curl
  install_package unzip
  install_package fzf
  install_package jq

  install_go_from_tarball
}

# ---------------------------------------------------------------------------
# Subcommand: tools (git-prompt, fzf, vim plugins)
# ---------------------------------------------------------------------------
install_git_prompt() {
  has curl || return
  echo "==> Updating git-prompt.sh..."
  mkdir -p "$HOME/.bash.d"
  curl -fsSL \
    https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh \
    -o "$HOME/.bash.d/git-prompt.sh"
}

install_fzf() {
  if has fzf || ! has git; then
    return
  fi

  echo "==> Installing fzf..."
  clone_or_update https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-zsh --no-fish --no-nushell
  mkdir -p "$HOME/bin"
  ln -sf "$HOME/.fzf/bin/fzf" "$HOME/bin/fzf"
}

install_vim_plugins() {
  has vim || return
  echo "==> Updating Vim plugins..."
  if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]] && has curl; then
    curl -fsSLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim -Nu "$HOME/.vimrc" -Es +PlugUpgrade +"PlugUpdate --sync" +"PlugClean! --sync" +qall! < /dev/null || true
}

cmd_tools() {
  install_git_prompt
  install_fzf
  install_vim_plugins
}

# ---------------------------------------------------------------------------
# Subcommand: repo (rbenv, ruby-build, ghq)
# ---------------------------------------------------------------------------
cmd_repo() {
  has git || return 0
  echo "==> Updating repositories..."

  clone_or_update https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  clone_or_update https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"

  if ! has ghq && [[ ! -x "$HOME/bin/ghq" ]]; then
    local go_bin=""
    if has go; then
      go_bin="go"
    elif [[ -x /usr/local/go/bin/go ]]; then
      go_bin="/usr/local/go/bin/go"
    fi
    if [[ -n $go_bin ]]; then
      echo "==> Installing ghq via go install..."
      GOBIN="$HOME/bin" "$go_bin" install github.com/x-motemen/ghq@latest
    fi
  fi
}

# ---------------------------------------------------------------------------
# Entrypoint
# ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [all|min|init|packages|tools|repo]
EOF
}

main() {
  local cmd=${1:-all}
  case $cmd in
    all)
      cmd_init
      cmd_packages
      cmd_tools
      cmd_repo
      ;;
    min)
      cmd_init
      cmd_tools
      ;;
    init)     cmd_init ;;
    packages) cmd_packages ;;
    tools|setup) cmd_tools ;;
    repo)     cmd_repo ;;
    -h|--help|help) usage ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
