#! /bin/sh

if type git >/dev/null 2>&1 && [[ -t ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    ln -s ~/.fzf/bin/fzf ~/bin/fzf
fi
