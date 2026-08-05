alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls -F --color=auto'
else
  alias ls='ls -F'
fi

alias grep='grep --color=auto'

if uname_info="$(uname -a)" && [[ $uname_info == *Linux* && $uname_info == *Microsoft* ]]; then
  umask 022
  alias pbcopy='clip.exe'
fi
