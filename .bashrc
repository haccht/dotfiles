# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'

export PAGER=less
export EDITOR=vim

export LANG=ja_JA.UTF-8
export LC_ALL=ja_JP.UTF-8
export OUTPUT_CHARSET=ja_JP.UTF-8

export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n\$ '
