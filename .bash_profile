# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs
export PAGER=less
export EDITOR=vim
export VISUAL=vim

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export HOME=${HOME%/}
export PATH="$HOME/bin:$HOME/local/bin:$PATH"
cd $HOME

# Ruby settings
export RUBYLIB="$HOME/lib"

# Go settings
export GOROOT=/usr/local/go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# rbenv settings
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# plenv settings
if [ -d $HOME/.plenv ]; then
  export PATH=$HOME/.plenv/bin:$PATH
  eval "$(plenv init -)"
fi

stty stop undef
