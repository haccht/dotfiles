# .bash_profile

# User specific environment and startup programs
export PAGER=less
export EDITOR=vim
export VISUAL=vim

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PATH="$HOME/bin:$PATH"

# IM settings
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Libvirt settings
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

# VirtualBox settings
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1

# Prompt settings (with git-prompt.sh)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export PS1='\[\e]0;\w\a\]\n\[\e[$(__term_color)m\]\u@\h \[\e[33m\]\w$(__git_ps1 " (%s)")\[\e[0m\]\n\$ '
else
  export PS1='\[\e]0;\w\a\]\n\[\e[1;35m\]\u@\h \[\e[33m\]\w$(__git_ps1 " (%s)")\[\e[0m\]\n\$ '
fi

# Go settings
export GOROOT=/usr/local/go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# dircolors
if [ -f "$HOME/.dircolors" ] ; then
  eval "$(dircolors -b $HOME/.dircolors)"
fi

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

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
