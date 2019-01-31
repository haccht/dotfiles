#! /bin/bash

confirm () {
  message=$1
  while :
  do
    echo -n "${message} [y/N]: "
    read answer
    case $answer in
      [yY]) return 0 ;;
      *)    return 1 ;;
    esac
  done
}

symlink () {
  mkdir -p $(dirname "$2")
  rm -f "$2"
  ln -snfv "$1" "$2"
}

hardlink () {
  mkdir -p $(dirname "$2")
  rm -f "$2"
  ln -nfv  "$1" "$2"
}

cwd=$(pwd)

symlink "$cwd/.bash_profile" "$HOME/.bash_profile"
symlink "$cwd/.bashrc"       "$HOME/.bashrc"
symlink "$cwd/.gemrc"        "$HOME/.gemrc"
symlink "$cwd/.gitconfig"    "$HOME/.gitconfig"
symlink "$cwd/.gitignore"    "$HOME/.gitignore"
symlink "$cwd/.tmux.conf"    "$HOME/.tmux.conf"
symlink "$cwd/.vimrc"        "$HOME/.vimrc"
symlink "$cwd/.irbrc"        "$HOME/.irbrc"

if confirm 'Install binaries?'; then
  mkdir -p "$HOME/bin"
  type volt >/dev/null 2>&1 || curl -L https://github.com/vim-volt/volt/releases/download/v0.3.2/volt-v0.3.2-linux-amd64 -o "$HOME/bin/volt" && chmod a+x "$HOME/bin/volt"
  type peco >/dev/null 2>&1 || curl -L https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz | tar xz && mv -f peco_linux_amd64/peco "$HOME/bin" && rm -rf peco_linux_amd64
  type dep  >/dev/null 2>&1 || curl -L https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
  type memo >/dev/null 2>&1 || curl -LO https://github.com/mattn/memo/releases/download/v0.0.4/memo_linux_amd64.zip && unzip memo_linux_amd64.zip -o -d "$HOME/bin" && rm -f memo_linux_amd64.zip
  type ghq  >/dev/null 2>&1 || curl -LO https://github.com/motemen/ghq/releases/download/v0.8.0/ghq_linux_amd64.zip && mkdir -p _ghq && unzip ghq_linux_amd64.zip -d _ghq && mv -f _ghq/ghq "$HOME/bin" && rm -rf _ghq ghq_linux_amd64.zip
fi

if confirm 'Install vim plugins?'; then
  $HOME/bin/volt get -u Shougo/unite.vim
  $HOME/bin/volt get -u tomasr/molokai
  $HOME/bin/volt get -u fatih/vim-go
  $HOME/bin/volt get -u vim-ruby/vim-ruby
  $HOME/bin/volt get -u bronson/vim-trailing-whitespace
  $HOME/bin/volt get -u thinca/vim-quickrun
  $HOME/bin/volt get -u tpope/vim-markdown
  $HOME/bin/volt get -u itchyny/lightline.vim
fi

if confirm 'Install git-prompt.sh?'; then
  curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "$HOME/.git-prompt.sh"
fi

if [[ $(uname -r) =~ Microsoft ]]; then
  WIN_USER=$(/mnt/c/Windows/System32/whoami.exe | awk -F'\' '{print $2}' | tr -cd [a-z])
  WIN_HOME="/mnt/c/Users/$WIN_USER"
  cp -f "$cwd/.hyper.js" "$WIN_HOME/.hyper.js"
  cp -f "$cwd/.vimrc"    "$WIN_HOME/.vimrc"
fi
