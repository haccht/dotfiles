# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=auto'
alias todoist='todoist --namespace --project-namespace --color'

eval `dircolors -b ~/.colorrc`
shopt -s histappend

if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
  alias pbcopy='clip.exe'
  umask 022
fi

if type peco > /dev/null 2>&1 && [[ -t 1 ]]; then
  function repo {
    cd ${GHQ_ROOT}/$(ghq list | peco --query ${@:-""})
  }

  peco_history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | awk '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' | peco --layout=bottom-up --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
  }
  bind -x '"\C-r":peco_history'
fi
