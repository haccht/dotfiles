#! /bin/bash

set -eu

UPDATE_BIN=0
GO_VERSION=go1.12.4.linux-amd64

install_package() {
  pkgname=$1

  if ${UPDATE_BIN} -eq 1 || type "${pkgname}" >/dev/null 2>&1; then
    type yum      >/dev/null 2>&1 && sudo yum install -y "${pkgname}"
    type yay      >/dev/null 2>&1 && sudo yay -S --noconfirm "${pkgname}"
    type pacman   >/dev/null 2>&1 && sudo pacman -S --noconfirm "${pkgname}"
    type apt-get  >/dev/null 2>&1 && sudo apt-get update && apt-get install -y
  fi
}

while getopts u OPT
do
  case $OPT in
    "u" ) UPDATE_BIN=1 ;;
  esac
done

ln -sfv "${PWD}/.bash_profile"   "${HOME}/.bash_profile"
ln -sfv "${PWD}/.bashrc"         "${HOME}/.bashrc"
ln -sfv "${PWD}/.colorrc"        "${HOME}/.colorrc"
ln -sfv "${PWD}/.gitconfig"      "${HOME}/.gitconfig"
ln -sfv "${PWD}/.gitignore"      "${HOME}/.gitignore"
ln -sfv "${PWD}/.tmux.conf"      "${HOME}/.tmux.conf"
ln -sfv "${PWD}/.vimrc"          "${HOME}/.vimrc"
ln -sfv "${PWD}/.gemrc"          "${HOME}/.gemrc"
ln -sfv "${PWD}/.irbrc"          "${HOME}/.irbrc"
ln -sfv "${PWD}/.hyper.linux.js" "${HOME}/.hyper.js"

if [[ $(uname -r) =~ Microsoft ]]; then
  WINUSER=$(/mnt/c/Windows/System32/whoami.exe | awk -F'\' '{print $2}' | tr -cd [a-z\.])
  WINHOME="/mnt/c/Users/$WINUSER"
  cp -f "$cwd/.hyper.windows.js" "$WINHOME/AppData/Roaming/Hyper/.hyper.js"
fi

mkdir -p "${HOME}/bin"
source "${HOME}/.bash_profile"

install_package 'vim'
install_package 'curl'
install_package 'unzip'

type go     >/dev/null 2>&1 || ( curl -L https://dl.google.com/go/${GO_VERSION}.tar.gz | sudo tar xz -C /usr/local )
curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.git-prompt.sh"

type vold   >/dev/null 2>&1 || ( go get -u github.com/vim-volt/volt )
type ghq    >/dev/null 2>&1 || ( go get -u github.com/motemen/ghq )
type memo   >/dev/null 2>&1 || ( go get -u github.com/mattn/memo )
type peco   >/dev/null 2>&1 || ( go get -u github.com/peco/peco )

volt get -u tomasr/molokai
volt get -u fatih/vim-go
volt get -u vim-ruby/vim-ruby
volt get -u airblade/vim-gitgutter
volt get -u bronson/vim-trailing-whitespace
volt get -u thinca/vim-quickrun
volt get -u tpope/vim-markdown
volt get -u itchyny/lightline.vim
volt get -u justinmk/vim-dirvish

git clone https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
git clone https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

( cd "${HOME}/.rbenv" && git pull origin master )
( cd "${HOME}/.rbenv/plugins/ruby-build" && git pull origin master )
