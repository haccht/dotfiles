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

if type fzf > /dev/null 2>&1 && [[ -t 1 ]]; then
  function tmuxa {
    tmux a -t $(tmux ls | sort -nr | fzf --no-sort --cycle | cut -d: -f1)
  }

  function repo {
    cd ${GHQ_ROOT}/$(ghq list | sort | fzf --no-sort --cycle --query ${@:-""} --prompt="Repository > ")
  }

  fzf_history() {
    declare l=$(history -w /dev/stdout | tac | grep -v '^#' | fzf --no-sort --cycle --exact --query "$LBUFFER" --prompt="History > ")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
  }
  [[ "$-" =~ "i" ]] && bind -x '"\C-r":fzf_history'
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
export PROMPT_COMMAND="history -a; __prompt_cmd"
