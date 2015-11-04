# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local

# User specific environment and startup programs
<<<<<<< HEAD

=======
export PATH=$PATH:$HOME/bin

# Go settings
>>>>>>> 9c32130cdd9e3ffde63a44116866b28b5d4219ab
export GOROOT=/usr/lib/golang
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

<<<<<<< HEAD
export PATH=$PATH:$HOME/bin
=======
# rbenv settings
>>>>>>> 9c32130cdd9e3ffde63a44116866b28b5d4219ab
if [ -d $HOME/.rbenv ]; then
  export PATH=$PATH:$HOME/.rbenv/bin
  eval "$(rbenv init -)"
fi
