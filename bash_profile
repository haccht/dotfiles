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

path_prepend() {
  local dir
  for dir in "$@"; do
    [[ -d $dir ]] || continue
    case ":$PATH:" in
      *":$dir:"*) ;;
      *) PATH="$dir:$PATH" ;;
    esac
  done
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  GOROOT=/opt/homebrew/opt/go/libexec

  if command -v brew >/dev/null 2>&1; then
    brew_prefix="$(brew --prefix)"
    eval "$("$brew_prefix"/bin/brew shellenv)"
    path_prepend "$brew_prefix/opt/curl/bin"
    path_prepend "$brew_prefix/opt/coreutils/libexec/gnubin"
  fi
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  path_prepend "$HOME/.rbenv/bin"

  rbenv_lazy_init() {
    eval "$(rbenv init --no-rehash -)"
    unset -f ruby gem rbenv rbenv_lazy_init
  }

  gem() { rbenv_lazy_init; gem "$@"; }
  ruby() { rbenv_lazy_init; ruby "$@"; }
  rbenv() { rbenv_lazy_init; rbenv "$@"; }
fi

if command -v ghq >/dev/null 2>&1; then
  export GHQ_ROOT="${GHQ_ROOT:-$GOPATH/src}"
fi

path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$GOPATH/bin"
path_prepend "$GOROOT/bin"

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -d "$HOME/.bash.d" ] ; then
    for f in "$HOME"/.bash.d/*.sh ; do
        [ -f "$f" ] && . "$f"
    done
fi
