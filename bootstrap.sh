#! /bin/bash

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

install_package vim
install_package curl
install_package unzip
install_package git
install_package jq

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/bin"

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
ln -sfv "${script_dir}/bash_profile"     "${HOME}/.bash_profile"
ln -sfv "${script_dir}/bashrc"           "${HOME}/.bashrc"
ln -sfv "${script_dir}/colorrc"          "${HOME}/.colorrc"
ln -sfv "${script_dir}/gitconfig"        "${HOME}/.gitconfig"
ln -sfv "${script_dir}/tmux.conf"        "${HOME}/.tmux.conf"
ln -sfv "${script_dir}/vimrc"            "${HOME}/.vimrc"
ln -sfv "${script_dir}/gemrc"            "${HOME}/.gemrc"
ln -sfv "${script_dir}/irbrc"            "${HOME}/.irbrc"

(
    GO_VERSION=$(curl -s https://go.dev/dl/?mode=json | jq -r .[0].version)
    [[ -f "${GOROOT}/bin/go" ]] || ( curl -L https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz | sudo tar xz -C /usr/local )

    export GHG_HOME="${HOME}"
    curl -sf https://gobinaries.com/Songmu/ghg/cmd/ghg | PREFIX="${HOME}/bin" sh

    "${HOME}/bin/ghg" get junegunn/fzf
    "${HOME}/bin/ghg" get x-motemen/ghq
    #"${HOME}/bin/ghg" get MichaelMure/mdr
    #"${HOME}/bin/ghg" get mattn/memo

    if [ -d "${HOME}/.rbenv/bin" ]; then
        ( cd "${HOME}/.rbenv" && git pull )
        ( cd "${HOME}/.rbenv/plugins/ruby-build" && git pull )
    else
        git clone https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
        git clone https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"
    fi

    mkdir -p "${HOME}/.bash.d"
    curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.bash.d/git-prompt.sh"

    vim -es -u ~/.vimrc +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean! +qall
)
