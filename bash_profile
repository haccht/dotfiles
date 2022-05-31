# .bash_profile

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"

export HISTSIZE=100000
export HISTCONTROL=ignoredups

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GOROOT=/usr/local/go
export GOPATH="$HOME"
export GO111MODULE=on

export GHQ_ROOT="$GOPATH/src"
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
export VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

if [ -f "$HOME/bin/ghg" ]; then
  export GHG_HOME="$HOME"
  export PATH="$(ghg bin):$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(~/.rbenv/bin/rbenv init -)"
fi

if [ -d "$HOME/.ndenv/bin" ]; then
  export PATH="$HOME/.ndenv/bin:$PATH"
  eval "$(ndenv init -)"
fi

if [ -d "$HOME/.deno/" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d "$HOME/.cargo/" ]; then
  eval "$HOME/.cargo/env"
fi

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
if [ -d "$HOME/.bash.d" ]; then
  for i in "$HOME"/.bash.d/*.sh; do source $i; done
fi
