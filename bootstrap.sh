#! /bin/bash

set -x

install_package() {
    pkgname=$1
    DEBIAN_FRONTEND=noninteractive
    if !(type "${pkgname}" >/dev/null 2>&1); then
        echo "Installing ${pkgname}..."
        type yay      >/dev/null 2>&1 && sudo yay -S --noconfirm "${pkgname}"
        type yum      >/dev/null 2>&1 && sudo yum install -y "${pkgname}"
        type apt-get  >/dev/null 2>&1 && sudo apt-get update && sudo apt-get install -y "${pkgname}"
        type pacman   >/dev/null 2>&1 && sudo pacman -S --noconfirm "${pkgname}"
    fi
}

clone_or_pull_repository() {
    remoterepo=$1
    directory=$2
    if [ -d "${directory}/.git" ]; then
        git -C "${directory}" pull "${remoterepo}"
    else
        git clone "${remoterepo}" "${directory}"
    fi
}

# packages
install_package git
install_package curl
install_package unzip
install_package jq
install_package vim

# directories
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/src"
mkdir -p "${HOME}/.bash.d"
curl -sL https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.bash.d/git-prompt.sh"

# dotfiles
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
ln -sfv "${script_dir}/bash_profile"     "${HOME}/.bash_profile"
ln -sfv "${script_dir}/bashrc"           "${HOME}/.bashrc"
ln -sfv "${script_dir}/colorrc"          "${HOME}/.colorrc"
ln -sfv "${script_dir}/gitconfig"        "${HOME}/.gitconfig"
ln -sfv "${script_dir}/tmux.conf"        "${HOME}/.tmux.conf"
ln -sfv "${script_dir}/gemrc"            "${HOME}/.gemrc"
ln -sfv "${script_dir}/irbrc"            "${HOME}/.irbrc"
ln -sfv "${script_dir}/vimrc"            "${HOME}/.vimrc"

# python
clone_or_pull_repository https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"

# ruby
clone_or_pull_repository https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
clone_or_pull_repository https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

# go
GOINSTALL=0
GOVERSION="$(curl -s 'https://go.dev/dl/?mode=json' | jq -r .[0].version)"
if [ -f "/usr/local/go/bin/go" ]; then
    /usr/local/go/bin/go version | grep ${GOVERSION} >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        GOINATALL=1
    fi
else
    GOINSTALL=1
fi
if [ $GOINSTALL -eq 1 ]; then
    sudo rm -rf /usr/local/go
    ( curl -sL https://dl.google.com/go/${GOVERSION}.linux-amd64.tar.gz | sudo tar xz -C /usr/local )
fi

# go binaries
export GOPATH=$HOME
/usr/local/go/bin/go install github.com/junegunn/fzf@latest
/usr/local/go/bin/go install github.com/x-motemen/ghq@latest

# vim plugins
vim -es -u ~/.vimrc +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean! +qall
