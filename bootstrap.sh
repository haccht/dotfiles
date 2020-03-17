#! /bin/bash

GO_VERSION=go1.13.5.linux-amd64

install_package() {
  pkgname=$1
  if !type "${pkgname}" >/dev/null 2>&1; then
    echo "Installing ${pkgname}..."
    type yum      >/dev/null 2>&1 && sudo yum install -y "${pkgname}"
    type yay      >/dev/null 2>&1 && sudo yay -S --noconfirm "${pkgname}"
    type pacman   >/dev/null 2>&1 && sudo pacman -S --noconfirm "${pkgname}"
    type apt-get  >/dev/null 2>&1 && sudo apt-get update && apt-get install -y
  fi
}

ln -sfv "${PWD}/bash_profile"   "${HOME}/.bash_profile"
ln -sfv "${PWD}/bashrc"         "${HOME}/.bashrc"
ln -sfv "${PWD}/colorrc"        "${HOME}/.colorrc"
ln -sfv "${PWD}/gitconfig"      "${HOME}/.gitconfig"
ln -sfv "${PWD}/tmux.conf"      "${HOME}/.tmux.conf"
ln -sfv "${PWD}/vimrc"          "${HOME}/.vimrc"
ln -sfv "${PWD}/gemrc"          "${HOME}/.gemrc"
ln -sfv "${PWD}/irbrc"          "${HOME}/.irbrc"
ln -sfv "${PWD}/hyper.linux.js" "${HOME}/.hyper.js"

if [[ $(uname -r) =~ Microsoft ]]; then
  WINUSER=$(/mnt/c/Windows/System32/whoami.exe | awk -F'\' '{print $2}' | tr -cd [a-z\.])
  WINHOME="/mnt/c/Users/${WINUSER}"
  cp -f "${PWD}/hyper.windows.js" "${WINHOME}/AppData/Roaming/Hyper/hyper.js"
fi

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/bin"

install_package vim
install_package curl
install_package unzip


(
    source "${HOME}/.bash_profile"

    [[ -f "${GOROOT}/bin/go"       ]] || ( curl -L https://dl.google.com/go/${GO_VERSION}.tar.gz | sudo tar xz -C /usr/local )
    [[ -f "${HOME}/.git-prompt.sh" ]] || ( curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.git-prompt.sh" )

    cd "${GOPATH}/src"
    go get -u golang.org/x/tools/cmd/gopls
    go get -u golang.org/x/tools/cmd/goimports
    go get -u github.com/Songmu/ghg/cmd/ghg

    cd "${HOME}"
    ghg get -u vim-volt/volt
    ghg get -u x-motemen/ghq
    ghg get -u mattn/memo
    ghg get -u peco/peco
    ghg get -u MichaelMure/mdr
    ghg get -u lemonade-command/lemonade

    cd "${HOME}"
    $(ghg bin)/volt get -u tomasr/molokai
    $(ghg bin)/volt get -u vim-ruby/vim-ruby
    $(ghg bin)/volt get -u airblade/vim-gitgutter
    $(ghg bin)/volt get -u bronson/vim-trailing-whitespace
    $(ghg bin)/volt get -u thinca/vim-quickrun
    $(ghg bin)/volt get -u tpope/vim-markdown
    $(ghg bin)/volt get -u itchyny/lightline.vim
    $(ghg bin)/volt get -u justinmk/vim-dirvish
    $(ghg bin)/volt get -u kana/vim-fakeclip
    $(ghg bin)/volt get -u prabirshrestha/async.vim
    $(ghg bin)/volt get -u prabirshrestha/vim-lsp
    $(ghg bin)/volt get -u prabirshrestha/asyncomplete.vim
    $(ghg bin)/volt get -u prabirshrestha/asyncomplete-lsp.vim
    $(ghg bin)/volt get -u mattn/vim-goimports
)

if [ -d "${HOME}/.rbenv/bin" ];then
  ( cd "${HOME}/.rbenv" && git pull origin master )
  ( cd "${HOME}/.rbenv/plugins/ruby-build" && git pull origin master )
else
  git clone https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
  git clone https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"
fi
