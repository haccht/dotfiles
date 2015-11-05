# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs
export PATH="$HOME/bin:$PATH"

# Go settings
export GOROOT="/usr/lib/golang"
export GOPATH="$HOME/gocode"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# rbenv settings
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# plenv settings
if [ -d "$HOME/.plenv" ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
fi
