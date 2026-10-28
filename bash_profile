# .bash_profile

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"
export BAT_STYLE=plain

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export BASH_SILENCE_DEPRECATION_WARNING=1

if [[ $OSTYPE == linux* ]]; then
  export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
  export QT_IM_MODULE=fcitx
  export GTK_IM_MODULE=fcitx
  export XMODIFIERS=@im=fcitx
fi

[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
