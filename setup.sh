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

if [ ! -e $HOME/.vim/dein ]
then
	read -p "Do you wish to install dein.vim from github.com? [yN]" yn
	case $yn in
		[Yy]*)
		curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
		sh installer.sh $HOME/.vim/dein
		rm installer.sh
		;;
	esac
fi

case "${OSTYPE}" in
	linux*)
		;;
	msys*)
		hardlink "$cwd/.gvimrc"       "$HOME/.gvimrc"
		hardlink "$cwd/.minttyrc"     "$HOME/.minttyrc"
		hardlink "$cwd/.vimperatorrc" "$HOME/.vimperatorrc"

		read -p "Do you wish to install keyhac config.py? [yN]" yn
		case $yn in
			[Yy]*)
				read -p "Please specify a path to install:" dir
				hardlink "$cwd/keyhac/config.py" "$dir/config.py"
				;;
		esac
		;;
esac
