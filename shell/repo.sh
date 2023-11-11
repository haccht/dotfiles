#! /bin/bash

set -x

clone_or_pull_repository() {
    remoterepo=$1
    directory=$2
    if [ -d "${directory}/.git" ]; then
        git -C "${directory}" pull "${remoterepo}"
    else
        git clone "${remoterepo}" "${directory}"
    fi
}

if type git >/dev/null 2>&1; then
    # ruby
    clone_or_pull_repository https://github.com/sstephenson/rbenv.git "${HOME}/.rbenv"
    clone_or_pull_repository https://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

    # python
    clone_or_pull_repository https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"
fi
