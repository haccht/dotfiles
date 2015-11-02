# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs
export PATH=$PATH:$HOME/bin

# Go settings
export GOROOT=/usr/lib/golang
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# rbenv settings
if [ -d $HOME/.rbenv ]; then
  export PATH=$PATH:$HOME/.rbenv/bin
  eval "$(rbenv init -)"
fi
