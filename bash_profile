# .bash_profile

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"
export TERM=xterm-256color
export BAT_STYLE=plain

export HISTSIZE=100000
export HISTCONTROL=ignoredups

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export GO111MODULE=on
export GOPATH="${GOPATH:-$HOME}"
export GOROOT="${GOROOT:-/usr/local/go}"
export GHQ_ROOT="${GHQ_ROOT:-$GOPATH/src}"

export BASH_SILENCE_DEPRECATION_WARNING=1
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

bash_profile_source=${BASH_SOURCE[0]}
while [[ -L $bash_profile_source ]]; do
  bash_profile_dir=$(cd "$(dirname "$bash_profile_source")" >/dev/null 2>&1 && pwd -P)
  bash_profile_target=$(readlink "$bash_profile_source")
  [[ $bash_profile_target == /* ]] || bash_profile_target="$bash_profile_dir/$bash_profile_target"
  bash_profile_source=$bash_profile_target
done
bash_profile_dir=$(cd "$(dirname "$bash_profile_source")" >/dev/null 2>&1 && pwd -P)

[[ -r "$bash_profile_dir/bash.d/00-path.bash" ]] && . "$bash_profile_dir/bash.d/00-path.bash"
[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

unset bash_profile_source bash_profile_dir bash_profile_target
