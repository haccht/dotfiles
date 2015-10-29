basedir=$(pwd)

for dotfile in .*
do
	[[ $dotfile == "." ]]    && continue
	[[ $dotfile == ".." ]]   && continue
	[[ $dotfile == ".git" ]] && continue

	ln -snfv $basedir/$dotfile $HOME/$dotfile
done

if [ ! -v $KEYHAC_DIR ]
then
	echo 
	echo " [installing keyhac config.py]"
	echo " $KEYHAC_DIR/config.py"
	cp $basedir/keyhac/config.py $KEYHAC_DIR/config.py
fi
