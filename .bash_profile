# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs
export PAGER=less
export EDITOR=vim

export LANG=ja_JA.UTF-8
export LC_ALL=ja_JP.UTF-8
export OUTPUT_CHARSET=ja_JP.UTF-8

export HOME=${HOME%/}
export PATH="$HOME/bin:$HOME/local/bin:$PATH"
cd $HOME

# Go settings
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
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
