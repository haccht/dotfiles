# .bash_profile

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"
export TERM=vt100

export HISTSIZE=100000
export HISTCONTROL=ignoredups

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GO111MODULE=on
export GOPATH="$HOME"
if [[ "$OSTYPE" == "darwin"* ]]; then
  export GOROOT=/opt/homebrew/opt/go/libexec
else
  export GOROOT=/usr/local/go
fi

export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
export VAGRANT_DISABLE_VBOXSYMLINKCREATE=1
export BASH_SILENCE_DEPRECATION_WARNING=1

export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init --no-rehash -)"
  (rbenv rehash &) 2> /dev/null
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

if [ -f "$HOME/bin/ghq" ]; then
  export GHQ_ROOT="$GOPATH/src"
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -d "$HOME/.bash.d" ] ; then
    for f in "$HOME"/.bash.d/*.sh ; do
        [ -f "$f" ] && . "$f"
    done
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thachimu/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/thachimu/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thachimu/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/thachimu/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# Setting PATH for Python 3.11
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
