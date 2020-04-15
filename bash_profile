# .bash_profile

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export OUTPUT_CHARSET=en_US.UTF-8

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export LESS="-iMR"

export HISTSIZE=50000
export HISTCONTROL=ignoredups
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export GOROOT=/usr/local/go
export GOPATH="$HOME"
export GO111MODULE=on
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"

export GHQ_ROOT=$GOPATH/src
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

if [ -f "$HOME/bin/ghg" ];then
  export GHG_HOME="$HOME"
  export PATH="$(ghg bin):$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ];then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(~/.rbenv/bin/rbenv init -)"
fi

if [ -z "$GEM_HOME" ];then
  export GEM_HOME="$HOME/.gem"
  export PATH="$GEM_HOME/bin:$PATH"
fi

if [ -d "$HOME/.ndenv/bin" ];then
  export PATH="$HOME/.ndenv/bin:$PATH"
  eval "$(ndenv init -)"
fi

eval `dircolors -b ~/.colorrc`
__term_color="$(expr '1;35')"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  __term_code=$(printf "%d" \'$(hostname))
  __term_color="$(expr ${__term_code} % 6 + 31)"
fi

prompt_cmd() {
    if [ $? != 0 ]; then
        local prompt_symbol="\[\e[0;31m\]$\[\e[0m\]"
    else
        local prompt_symbol="\[\e[0m\]$"
    fi

    [[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
    if type __git_ps1 >/dev/null 2>&1; then
        GIT_PS1_SHOWDIRTYSTATE=1
        PS1="\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w$(__git_ps1)\n${prompt_symbol} "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w\n${prompt_symbol} "
    fi
}
PROMPT_COMMAND=prompt_cmd

[[ -f "$HOME/.bashrc" ]]     && . "$HOME/.bashrc"
[[ -f "$HOME/.bash_local" ]] && . "$HOME/.bash_local"
