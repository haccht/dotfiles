# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Get the functions for PS1
[[ -f ~/.git-prompt.sh ]] && . ~/.git-prompt.sh
function __term_color {
	name=$(hostname)
	code=$(echo $(printf "%d" \'${name}))
	expr ${code} % 6 + 31
}

# Aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -hFG --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=auto'

# Source local definitions
[[ -f ~/.bash_local ]] && . ~/.bash_local
