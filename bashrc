# .bashrc

[[ -f /etc/bashrc ]] && . /etc/bashrc

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=never'

shopt -s histappend

if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
  alias pbcopy='clip.exe'
  umask 022
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  alias pbcopy='lemonade copy'
  alias pbpaste='lemonade paste'
fi

if type peco > /dev/null 2>&1 && [[ -t 1 ]]; then
  function attach {
    tmux a -t $(tmux ls | peco --layout=bottom-up | cut -d: -f1)
  }

  function repo {
    cd ${GHQ_ROOT}/$(ghq list | sort | peco --query ${@:-""})
  }

  peco_history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | awk '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' | peco --layout=bottom-up --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
  }
  [[ "$-" =~ "i" ]] && bind -x '"\C-r":peco_history'
fi
