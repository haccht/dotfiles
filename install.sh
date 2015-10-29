basedir=$(pwd)

for dotfile in .*
do
	[[ $dotfile == "." ]]    && continue
	[[ $dotfile == ".." ]]   && continue
	[[ $dotfile == ".git" ]] && continue

	ln -snfv $basedir/$dotfile $HOME/$dotfile
done

if [ $(uname -s) == "MSYS_NT-6.3" ]
then
	if [ ! -v $KEYHAC_DIR ]
	then
		echo
		echo " [installing keyhac config.py]"
		echo " $KEYHAC_DIR/config.py"
		ln -nfv $basedir/windows/keyhac/config.py $KEYHAC_DIR/config.py
	fi

	ln -nfv $basedir/windows/.gvimrc       $HOME/.gvimrc
	ln -nfv $basedir/windows/.vimperatorrc $HOME/.vimperatorrc
fi
