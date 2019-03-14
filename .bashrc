# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"

export PATH="$HOME/bin:$HOME/local/bin:$PATH"

# aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=auto'

test -d "$HOME/.rbenv" && eval "$(~/.rbenv/bin/rbenv init -)"
test -d "$HOME/.linuxbrew" && eval $(~/.linuxbrew/bin/brew shellenv)
test -d "/home/linuxbrew/.linuxbrew" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# history settings
export HISTSIZE=9999
export HISTCONTROL=ignoredups

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
shopt -s histappend

# prompt settings
function __term_color {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    code=$(echo $(printf "%d" \'$(hostname)))
    expr ${code} % 6 + 31
  else
    expr "1;35"
  fi
}

# Go settings
export GOROOT=/usr/local/go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1='\[\e]0;\w\a\]\n\[\e[$(__term_color)m\]\u@\h \[\e[33m\]\w$(__git_ps1)\[\e[0m\]'$'\n\$ '
else
  export PS1='\[\e]0;\w\a\]\n\[\e[$(__term_color)m\]\u@\h \[\e[33m\]\w\[\e[0m\]'$'\n\$ '
fi

# Libvirt settings
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

# for WSL shell
if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
  alias pbcopy='clip.exe'
fi

# ghq settings
if type ghq > /dev/null 2>&1; then
  export GHQ_ROOT=$GOPATH/src
  function repo {
    cd ${GHQ_ROOT}/$(ghq list | peco --query ${@:-""})
  }
fi

# history backward search using peco
if type peco > /dev/null 2>&1 && [[ -t 1 ]]; then
  peco_history() {
    declare l=$(HISTTIMEFORMAT= history|LC_ALL=C sort -r|awk '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'|peco --layout=bottom-up --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
  }
  bind -x '"\C-r": peco_history'
fi
