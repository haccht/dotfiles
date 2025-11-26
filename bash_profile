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

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export GO111MODULE=on
export GOPATH="$HOME"
export GOROOT=/usr/local/go

export BASH_SILENCE_DEPRECATION_WARNING=1
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

if [[ "$OSTYPE" == "darwin"* ]]; then
    export GOROOT=/opt/homebrew/opt/go/libexec

    BREW_PREFIX="$(brew --prefix)"
    eval "$($BREW_PREFIX/bin/brew shellenv)"
    export PATH="$BREW_PREFIX/opt/curl/bin:$PATH"
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  fi
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  rbenv_lazy_init() {
    eval "$(rbenv init --no-rehash -)"
    unset -f ruby gem rbenv rbenv_lazy_init
  }

  gem() { rbenv_lazy_init; gem "$@"; }
  ruby() { rbenv_lazy_init; ruby "$@"; }
  rbenv() { rbenv_lazy_init; rbenv "$@"; }
fi

if [ -f "$HOME/bin/ghq" ]; then
  export GHQ_ROOT="$GOPATH/src"
fi

export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -d "$HOME/.bash.d" ] ; then
    for f in "$HOME"/.bash.d/*.sh ; do
        [ -f "$f" ] && . "$f"
    done
fi
