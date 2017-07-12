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

function term_color {
	name=$(hostname)
	code=$(echo $(printf "%d" \'${name}))
	expr ${code} % 6 + 31
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	export PS1='\[\e]0;\w\a\]\n\[\e[$(term_color)m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
else
	export PS1='\[\e]0;\w\a\]\n\[\e[1;35m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi
