#! /bin/bash

GO_VERSION=go1.17.1.linux-amd64

install_package() {
  pkgname=$1
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

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/bin"

ln -sfv "${PWD}/bash_profile"     "${HOME}/.bash_profile"
ln -sfv "${PWD}/bashrc"           "${HOME}/.bashrc"
ln -sfv "${PWD}/colorrc"          "${HOME}/.colorrc"
ln -sfv "${PWD}/gitconfig"        "${HOME}/.gitconfig"
ln -sfv "${PWD}/tmux.conf"        "${HOME}/.tmux.conf"
ln -sfv "${PWD}/vimrc"            "${HOME}/.vimrc"
ln -sfv "${PWD}/gemrc"            "${HOME}/.gemrc"
ln -sfv "${PWD}/irbrc"            "${HOME}/.irbrc"

(
    [[ -f "${GOROOT}/bin/go" ]] || ( curl -L https://dl.google.com/go/${GO_VERSION}.tar.gz | sudo tar xz -C /usr/local )

    curl -sf https://gobinaries.com/junegunn/fzf       | PREFIX="${HOME}/bin" sh
    curl -sf https://gobinaries.com/Songmu/ghg/cmd/ghg | PREFIX="${HOME}/bin" sh

    export GHG_HOME="$HOME"
    "${HOME}/bin/ghg" get x-motemen/ghq
    "${HOME}/bin/ghg" get MichaelMure/mdr
    "${HOME}/bin/ghg" get mattn/memo

    if [ ! -d "${HOME}/.rbenv/bin" ];then
      git clone https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
      git clone https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"
    fi

    mkdir -p "${HOME}/.bash.d"
    [[ -f "${HOME}/.bash.d/.git-prompt.sh" ]] || ( curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.bash.d/git-prompt.sh" )
)
