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
  type fzf  >/dev/null 2>&1 || curl -L https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz | tar xz -C "$HOME/bin"
  type dep  >/dev/null 2>&1 || curl -L https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

  if !(type ghq >/dev/null 2>&1); then
    mkdir _ghq
    curl -LO https://github.com/motemen/ghq/releases/download/v0.8.0/ghq_linux_amd64.zip
    unzip ghq_linux_amd64.zip -d _ghq
    mv _ghq/ghq "$HOME/bin"
    rm -rf _ghq ghq_linux_amd64.zip
  fi
fi

if confirm 'Install vim plugins?'; then
  $HOME/bin/volt get Shougo/unite.vim
  $HOME/bin/volt get tomasr/molokai
  $HOME/bin/volt get fatih/vim-go
  $HOME/bin/volt get vim-ruby/vim-ruby
  $HOME/bin/volt get bronson/vim-trailing-whitespace
  $HOME/bin/volt get thinca/vim-quickrun
  $HOME/bin/volt get tpope/vim-markdown
  $HOME/bin/volt get itchyny/lightline.vim
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
