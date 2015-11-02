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

case "${OSTYPE}" in
	linux*)
		symlink  "$cwd/.vim/bundle/neobundle.vim" "$HOME/.vim/bundle/neobundle.vim"
		symlink  "$cwd/.vim/bundle/badwolf"       "$HOME/.vim/bundle/badwolf"
		;;
	msys*)
		hardlink "$cwd/.vim/bundle/neobundle.vim" "$HOME/.vim/bundle/neobundle.vim"
		hardlink "$cwd/.vim/bundle/badwolf"       "$HOME/.vim/bundle/badwolf"

		hardlink "$cwd/.gvimrc"       "$HOME/.gvimrc"
		hardlink "$cwd/.minttyrc"     "$HOME/.minttyrc"
		hardlink "$cwd/.vimperatorrc" "$HOME/.vimperatorrc"

		read -p "Do you wish to install keyhac config.py? [yN]" yn
		case $yn in
			[Yy]*)
				read -p "Please specify a path to install:" dir
				hardlink "$cwd/config.py" "$(dirname $dir)/config.py"
				;;
		esac
		;;
esac
