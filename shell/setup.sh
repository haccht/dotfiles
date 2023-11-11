#! /bin/bash

set -x

# git-prompt.sh
if type curl >/dev/null 2>&1; then
    mkdir -p "${HOME}/.bash.d"
    curl -sL https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -o "${HOME}/.bash.d/git-prompt.sh"
fi

# install fzf if not install via package task
if !(type fzf >/dev/null 2>&1); then
    if type git >/dev/null 2>&1; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
        ${HOME}/.fzf/install
        ln -s ${HOME}/.fzf/bin/fzf ${HOME}/bin/fzf
    fi
fi

# vim plugins
if type vim >/dev/null 2>&1; then
    vim -es -u ~/.vimrc +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean! +qall
fi
