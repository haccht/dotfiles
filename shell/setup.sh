#! /bin/bash

set -x

# git-prompt.sh
if type curl >/dev/null 2>&1; then
    mkdir -p "${HOME}/.bash.d"
    curl -sL https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.bash.d/git-prompt.sh"
fi

# vim plugins
if type vim >/dev/null 2>&1; then
    vim -es -u ~/.vimrc +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean! +qall
fi
