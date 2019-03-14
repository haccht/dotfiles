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

cwd=$(pwd)
symlink "$cwd/.bash_profile" "$HOME/.bash_profile"
symlink "$cwd/.bashrc"       "$HOME/.bashrc"
symlink "$cwd/.gemrc"        "$HOME/.gemrc"
symlink "$cwd/.gitconfig"    "$HOME/.gitconfig"
symlink "$cwd/.gitignore"    "$HOME/.gitignore"
symlink "$cwd/.tmux.conf"    "$HOME/.tmux.conf"
symlink "$cwd/.vimrc"        "$HOME/.vimrc"
symlink "$cwd/.irbrc"        "$HOME/.irbrc"

if [[ $(uname -r) =~ Microsoft ]]; then
  WIN_USER=$(/mnt/c/Windows/System32/whoami.exe | awk -F'\' '{print $2}' | tr -cd [a-z])
  WIN_HOME="/mnt/c/Users/$WIN_USER"

  cp -f "$cwd/.hyper.js" "$WIN_HOME/.hyper.js"
  cp -f "$cwd/.vimrc"    "$WIN_HOME/.vimrc"
fi

if confirm 'Install binaries?'; then
  mkdir -p "$HOME/bin"

  if [ ! -d "$HOME/.linuxbrew" ]; then
    mkdir -p "$HOME/.linuxbrew/bin"

    git clone https://github.com/Homebrew/brew "$HOME/.linuxbrew/Homebrew"
    ln -s "$HOME/.linuxbrew/Homebrew/bin/brew" "$HOME/.linuxbrew/bin"

    eval $(~/.linuxbrew/bin/brew shellenv)

    type peco >/dev/null 2>&1 || brew install peco
    type ghq  >/dev/null 2>&1 || brew install ghq
    type dep  >/dev/null 2>&1 || brew install --ignore-dependencies dep
    brew update
  fi

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

  curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "$HOME/.git-prompt.sh"
fi
