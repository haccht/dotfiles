# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs

export GOROOT=/usr/lib/golang
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

export PATH=$PATH:$HOME/bin
if [ -d $HOME/.rbenv ]; then
  export PATH=$PATH:$HOME/.rbenv/bin
  eval "$(rbenv init -)"
fi
