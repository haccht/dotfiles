# .bashrc

[[ -f /etc/bashrc ]] && . /etc/bashrc
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto -I NTUSER.\* -I ntuser.\*'
alias grep='grep --color=never'

shopt -s histappend

# wsl
if [[ `uname -a` =~ Linux && `uname -a` =~ Microsoft ]]; then
    umask 022
    alias pbcopy='clip.exe'
fi

# function
if [[ -t 1 ]]; then
    _edit_wo_executing() {
        tmpf="$(mktemp)"
        printf '%s\n' "$READLINE_LINE" > "$tmpf"
        "$EDITOR" "$tmpf"
        READLINE_LINE="$(<"$tmpf")"
        READLINE_POINT="${#READLINE_LINE}"
        rm -f "$tmpf"
    }
    bind -x '"\C-x\C-e":_edit_wo_executing'
fi

# fzf
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# ghq
if type ghq >/dev/null 2>&1 && [[ -t 1 ]]; then
    repo() {
        selected="$(ghq list | sort | fzf --no-sort --cycle --query ${@:-''} --prompt='Repository > ')"
        if [ -n "$selected" ]; then cd "$GHQ_ROOT/$selected"; fi
    }
fi

# goblin
if type curl >/dev/null 2>&1 && [[ -t 1 ]]; then
    goblin() {
        curl -sf "https://goblin.run/${1}" | PREFIX=~/bin sh
    }
fi

# prompt
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
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\n${color_1}\u@\h ${color_2}\w${git_ps1}\n${symbol} "
            ;;
        *)
            ;;
    esac
}
export PROMPT_COMMAND=prompt_cmd
