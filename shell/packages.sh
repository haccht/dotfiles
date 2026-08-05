#!/usr/bin/env bash

set -euo pipefail

has() {
  command -v "$1" >/dev/null 2>&1
}

install_package() {
  local pkgname=$1

  if has "$pkgname"; then
    return
  fi

  echo "Installing $pkgname..."
  if has apt-get; then
    sudo env DEBIAN_FRONTEND=noninteractive apt-get update -y
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkgname"
  elif has pacman; then
    sudo pacman -S --noconfirm "$pkgname"
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
  if has go || [[ $OSTYPE == darwin* ]]; then
    return
  fi

  local goos goarch goversion
  goos=$(uname -s | tr '[:upper:]' '[:lower:]')
  goarch=$(uname -m)
  case $goarch in
    x86_64) goarch=amd64 ;;
    aarch64|arm64) goarch=arm64 ;;
    *) echo "Unsupported Go architecture: $goarch" >&2; return 1 ;;
  esac

  goversion="$(curl -fsSL 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')"
  curl -fsSL "https://dl.google.com/go/${goversion}.${goos}-${goarch}.tar.gz" |
    sudo tar xz -C /usr/local
}

install_homebrew
install_xcode_tools

if [[ $OSTYPE == darwin* ]]; then
  install_package bash
  install_package bash-completion
  install_package go
fi

for package in git vim bat curl unzip fzf jq; do
  install_package "$package"
done

install_go_from_tarball
