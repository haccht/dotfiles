# .bashrc

[[ -f /etc/bashrc ]] && . /etc/bashrc
if ! shopt -oq posix; then
    if [[ -r /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -r /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'

shopt -s histappend

# wsl
if uname_info="$(uname -a)" && [[ $uname_info == *Linux* && $uname_info == *Microsoft* ]]; then
    umask 022
    alias pbcopy='clip.exe'
fi

# function
if [[ -t 1 && $- == *i* ]]; then
    _edit_wo_executing() {
        local tmpf="$(mktemp)"
        printf '%s\n' "$READLINE_LINE" > "$tmpf"
        "${EDITOR:-vi}" "$tmpf"
        READLINE_LINE="$(<"$tmpf")"
        READLINE_POINT="${#READLINE_LINE}"
        rm -f "$tmpf"
    }
    bind -x '"\C-x\C-e":_edit_wo_executing'
fi

mcd() {
    local dir="${1}"
    mkdir -p "${dir}" && cd "${dir}" || return
}

# fzf
[[ -r ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -r /usr/share/doc/fzf/examples/key-bindings.bash ]] && source /usr/share/doc/fzf/examples/key-bindings.bash

# ghq
if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1 && [[ -t 1 ]]; then
    repo() {
        local selected
        selected="$(ghq list | sort | fzf --no-sort --cycle --query "${*:-}" --prompt='Repository > ')"
        [[ -n $selected ]] && cd "$GHQ_ROOT/$selected"
    }
fi

# prompt
theme_color_1=(34 202 216 39 165 243 214)
theme_color_2=(154 220 229 226 219 254 33)
theme_index=$((0x$(hostname | md5sum | cut -c 1-3) % ${#theme_color_1[@]}))
prompt_cmd() {
    local status_symbol="\[\e[0m\]$"
    if [[ $? -ne 0 ]]; then
        status_symbol="\[\e[0;31m\]$\[\e[0m\]"
    fi
    history -a

    local git_ps1=""
    local color_1="\[\e[38;5;${theme_color_1[$theme_index]}m\]"
    local color_2="\[\e[38;5;${theme_color_2[$theme_index]}m\]"
    if command -v __git_ps1 >/dev/null 2>&1; then
        GIT_PS1_SHOWDIRTYSTATE=1
        git_ps1=$(__git_ps1)
    fi
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\n${color_1}\u@\h ${color_2}\w${git_ps1}\n${status_symbol} "
            ;;
        *)
            ;;
    esac
}
export PROMPT_COMMAND=prompt_cmd
