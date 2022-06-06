# .bashrc

[[ -f /etc/bashrc ]] && . /etc/bashrc

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=never'

shopt -s histappend
eval `dircolors -b ~/.colorrc`

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


theme_color_1=( 34 202 216  39 165 243 214)
theme_color_2=(154 220 229 226 219 254 33)
theme_index="$(expr $(printf %d "0x$(hostname | md5sum | cut -c 1-3)") % ${#theme_color_1[@]})"

prompt_cmd() {
    [[ $? -eq 0 ]] && local symbol="\[\e[0m\]$" || local symbol="\[\e[0;31m\]$\[\e[0m\]"
    history -a

    local git_ps1
    local color_1="\[\e[38;5;${theme_color_1[$theme_index]}m\]"
    local color_2="\[\e[38;5;${theme_color_2[$theme_index]}m\]"
    if type __git_ps1 >/dev/null 2>&1; then
        GIT_PS1_SHOWDIRTYSTATE=1
        git_ps1=$(__git_ps1)
    fi
    PS1="\n${color_1}\u@\h ${color_2}\w${git_ps1}\n${symbol} "
}
export PROMPT_COMMAND=prompt_cmd
