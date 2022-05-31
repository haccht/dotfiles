# .bashrc

[[ -f /etc/bashrc ]] && . /etc/bashrc

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=never'

shopt -s histappend

if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
  umask 022
  alias pbcopy='clip.exe'
fi

if type fzf > /dev/null 2>&1 && [[ -t 1 ]]; then
  repo() {
    selected="$(ghq list | sort | fzf --no-sort --cycle --query ${@:-''} --prompt='Repository > ')"
    if [ -n "$selected" ]; then cd "$GHQ_ROOT/$selected"; fi
  }

  fzf_history() {
    declare l=$(history -w /dev/stdout | tac | grep -v '^#' | fzf --no-sort --cycle --exact --query "$LBUFFER" --prompt="History > ")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
  }
  [[ "$-" =~ "i" ]] && bind -x '"\C-r":fzf_history'
fi

#eval `dircolors -b ~/.colorrc`
eval "$(starship init bash)"
