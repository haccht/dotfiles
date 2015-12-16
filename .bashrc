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

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	if [ "$LOGNAME" = "vagrant" ]; then
		export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
	else
		export PS1='\[\e]0;\w\a\]\n\[\e[31m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
	fi
else
	export PS1='\[\e]0;\w\a\]\n\[\e[1;34m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi
