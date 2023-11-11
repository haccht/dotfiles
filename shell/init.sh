#! /bin/bash

set -x

# directories
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/src"

# dotfiles
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
ln -sfv "${script_dir}/bash_profile"     "${HOME}/.bash_profile"
ln -sfv "${script_dir}/bashrc"           "${HOME}/.bashrc"
ln -sfv "${script_dir}/gitconfig"        "${HOME}/.gitconfig"
ln -sfv "${script_dir}/tmux.conf"        "${HOME}/.tmux.conf"
ln -sfv "${script_dir}/gemrc"            "${HOME}/.gemrc"
ln -sfv "${script_dir}/irbrc"            "${HOME}/.irbrc"
ln -sfv "${script_dir}/vimrc"            "${HOME}/.vimrc"
