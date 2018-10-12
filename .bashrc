# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim

export PATH="$HOME/bin:$PATH"

export HISTSIZE=9999
export HISTCONTROL=ignoredups

if type fzf > /dev/null 2>&1 && [[ -t 1 ]]; then
  bind -x '"\C-r":history -n;READLINE_LINE=$(history|sed "s/ *[^ ]*  //"|fzf -e +s --tac);READLINE_POINT=${#READLINE_LINE}'
fi

function __term_color {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    code=$(echo $(printf "%d" \'$(hostname)))
    expr ${code} % 6 + 31
  else
    expr "1;35"
  fi
}

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1='\[\e]0;\w\a\]\n\[\e[$(__term_color)m\]\u@\h \[\e[33m\]\w$(__git_ps1)\[\e[0m\]'$'\n\$ '
else
  export PS1='\[\e]0;\w\a\]\n\[\e[$(__term_color)m\]\u@\h \[\e[33m\]\w\[\e[0m\]'$'\n\$ '
fi

if [ -f "$HOME/.dircolors" ] ; then
  eval "$(dircolors -b $HOME/.dircolors)"
fi

# for WSL shell
if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
  alias pbcopy='clip.exe'
fi

# Libvirt settings
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

# Go settings
export GOROOT=/usr/local/go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GHQ_ROOT=$GOPATH/src

# rbenv settings
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# Aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=auto'
