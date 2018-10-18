#! /bin/bash

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

if [ ! -e "$HOME/.vim/dein" ]; then
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  sh installer.sh $HOME/.vim/dein
  rm installer.sh
fi

if [ ! -e "$HOME/.git-prompt.sh" ]; then
  curl -L https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "$HOME/.git-prompt.sh"
fi

if [ ! -e "$HOME/bin/fzf" ]; then
  mkdir -p "$HOME/bin"
  curl -L https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz | tar xz -C "$HOME/bin"
fi

case "${OSTYPE}" in
  msys*)
    read -p "Do you wish to install keyhac config.py? [yN]" yn
    case $yn in
      [Yy]*)
        read -p "Please specify a path to install:" dir
        hardlink "$cwd/keyhac/config.py" "$dir/config.py"
        ;;
    esac
    ;;
esac
