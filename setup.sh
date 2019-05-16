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

confirm_installed () {
  type $1 >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "$1 not installed"
    exit 1
  fi
}

symlink () {
  mkdir -p $(dirname "$2")
  rm -f "$2"
  ln -snfv "$1" "$2"
}

cwd=$(pwd)
symlink "$cwd/.bash_profile" "$HOME/.bash_profile"
symlink "$cwd/.bashrc"       "$HOME/.bashrc"
symlink "$cwd/.colorrc"      "$HOME/.colorrc"
symlink "$cwd/.gitconfig"    "$HOME/.gitconfig"
symlink "$cwd/.gitignore"    "$HOME/.gitignore"
symlink "$cwd/.tmux.conf"    "$HOME/.tmux.conf"
symlink "$cwd/.vimrc"        "$HOME/.vimrc"
symlink "$cwd/.gemrc"        "$HOME/.gemrc"
symlink "$cwd/.irbrc"        "$HOME/.irbrc"

if [[ $(uname -r) =~ Microsoft ]]; then
  WINUSER=$(/mnt/c/Windows/System32/whoami.exe | awk -F'\' '{print $2}' | tr -cd [a-z\.])
  WINHOME="/mnt/c/Users/$WINUSER"

  cp -f "$cwd/.vimrc" "$WINHOME/.vimrc"
  cp -f "$cwd/.hyper.windows.js" "$WINHOME/AppData/Roaming/Hyper/.hyper.js"
else
  symlink "$cwd/.hyper.linux.js" "$HOME/.hyper.js"
fi

mkdir -p "$HOME/bin"

if confirm 'Install rbenv?'; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

if confirm 'Install go binaries?'; then
  confirm_installed curl

  source "$HOME/.bashrc"
  type go   >/dev/null 2>&1 || (curl -L https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz | sudo tar xz -C /usr/local)
  type dep  >/dev/null 2>&1 || (curl -L https://raw.githubusercontent.com/golang/dep/master/install.sh | sh)
fi

if confirm 'Install vim plugins?'; then
  confirm_installed vim
  confirm_installed curl

  type volt >/dev/null 2>&1 || (curl -L https://github.com/vim-volt/volt/releases/download/v0.3.2/volt-v0.3.2-linux-amd64 -o "$HOME/bin/volt" && chmod a+x "$HOME/bin/volt")

  $HOME/bin/volt get -u tomasr/molokai
  $HOME/bin/volt get -u fatih/vim-go
  $HOME/bin/volt get -u vim-ruby/vim-ruby
  $HOME/bin/volt get -u airblade/vim-gitgutter
  $HOME/bin/volt get -u bronson/vim-trailing-whitespace
  $HOME/bin/volt get -u thinca/vim-quickrun
  $HOME/bin/volt get -u tpope/vim-markdown
  $HOME/bin/volt get -u itchyny/lightline.vim
  $HOME/bin/volt get -u justinmk/vim-dirvish
fi

if confirm 'Install other files?'; then
  confirm_installed unzip
  confirm_installed curl

  type peco >/dev/null 2>&1 || (curl -L https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz | tar xz && mv -f peco_linux_amd64/peco "$HOME/bin" && rm -rf peco_linux_amd64)
  type memo >/dev/null 2>&1 || (curl -LO https://github.com/mattn/memo/releases/download/v0.0.4/memo_linux_amd64.zip && unzip memo_linux_amd64.zip -d "$HOME/bin" && rm -f memo_linux_amd64.zip)
  type ghq  >/dev/null 2>&1 || (curl -LO https://github.com/motemen/ghq/releases/download/v0.8.0/ghq_linux_amd64.zip && mkdir -p _ghq && unzip ghq_linux_amd64.zip -d _ghq && mv -f _ghq/ghq "$HOME/bin" && rm -rf _ghq ghq_linux_amd64.zip)

  curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "$HOME/.git-prompt.sh"
fi
