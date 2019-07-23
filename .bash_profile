# .bash_profile

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

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

export PATH="$HOME/bin:$HOME/local/bin:$PATH"

export GOROOT=/usr/local/go
export GOPATH=$HOME
export GO111MODULE=on
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

export GHQ_ROOT=$GOPATH/src
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

if [ -d "$HOME/.rbenv" ];then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(~/.rbenv/bin/rbenv init -)"
fi

__term_color="$(expr '1;35')"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  __term_code=$(printf "%d" \'$(hostname))
  __term_color="$(expr ${__term_code} % 6 + 31)"
fi
eval `dircolors -b ~/.colorrc`

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1='\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w$(__git_ps1)\[\e[0m\]'$'\n\$ '
else
  export PS1='\[\e]0;\w\a\]\n\[\e[${__term_color}m\]\u@\h \[\e[33m\]\w\[\e[0m\]'$'\n\$ '
fi
