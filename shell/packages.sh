#! /bin/bash

set -x

install_package() {
    pkgname=$1
    DEBIAN_FRONTEND=noninteractive
    if !(type "${pkgname}" >/dev/null 2>&1); then
        echo "Installing ${pkgname}..."
        type apt-get >/dev/null 2>&1 && sudo apt-get update -y && sudo apt-get install -y "${pkgname}"
        type pacman  >/dev/null 2>&1 && sudo pacman -S --noconfirm "${pkgname}"
        type yum     >/dev/null 2>&1 && sudo yum install -y "${pkgname}"
        type brew    >/dev/null 2>&1 && brew install "${pkgname}"
    fi
}

# macos packages
if [[ "${OSTYPE}" == "darwin"* ]]; then
    # homebrew
    if [ ! -f /opt/homebrew/bin/brew ]; then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    # xcode
    if !(xcode-select -p >/dev/null 2>&1); then
        xcode-select --install
    fi

    # use bash instead of zsh in macos
    install_package bash
    install_package bash-completion
    sudo chsh -s /bin/bash ${USER}
fi

# common packages
install_package git
install_package vim
install_package curl
install_package unzip
install_package fzf
install_package jq

# go
if !(type go >/dev/null 2>&1); then
    GOVERSION="$(curl -s 'https://go.dev/dl/?mode=json' | jq -r .[0].version)"
    ( curl -sL https://dl.google.com/go/${GOVERSION}.linux-amd64.tar.gz | sudo tar xz -C /usr/local )
fi
