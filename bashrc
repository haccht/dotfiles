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

eval `dircolors -b ~/.colorrc`
__term_color="$(expr '1;35')"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  __term_code=$(printf "%d" \'$(hostname))
  __term_color="$(expr ${__term_code} % 6 + 31)"
fi

__prompt_cmd() {
    if [ $? == 0 ]; then
        local prompt_symbol="\[\e[0m\]$"
    else
        local prompt_symbol="\[\e[0;31m\]$\[\e[0m\]"
    fi

    [[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
    if type __git_ps1 >/dev/null 2>&1; then
        GIT_PS1_SHOWDIRTYSTATE=1
        PS1="\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w$(__git_ps1)\n${prompt_symbol} "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w\n${prompt_symbol} "
    fi
}
PROMPT_COMMAND="__prompt_cmd"
