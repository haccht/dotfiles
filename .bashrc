# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Functions for PS1
[[ -f ~/.git-prompt.sh ]] && . ~/.git-prompt.sh
function __term_color {
  name=$(hostname)
  code=$(echo $(printf "%d" \'${name}))
  expr ${code} % 6 + 31
}

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim

export HISTSIZE=2000
export HISTCONTROL=ignoredups

export PATH="$HOME/bin:$PATH"

# VirtualBox settings(WSL)
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1

# Libvirt settings
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

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

# rbenv settings
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv settings
if [ -d "$HOME/.pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv virtualenv-init -)"
fi

# plenv settings
if [ -d $HOME/.plenv ]; then
  export PATH=$HOME/.plenv/bin:$PATH
  eval "$(plenv init -)"
fi

# dircolors
if [ -f "$HOME/.dircolors" ] ; then
  eval "$(dircolors -b $HOME/.dircolors)"
fi

# History backward search using fzf
if type fzf > /dev/null 2>&1; then
  bind -x '"\C-r":history -n;READLINE_LINE=$(history|sed "s/ *[^ ]*  //"|fzf -e +s --tac);READLINE_POINT=${#READLINE_LINE}'
fi

# Aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -hFG --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=auto'
