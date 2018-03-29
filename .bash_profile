# .bash_profile

# User specific environment and startup programs
# IM settings(GUI)
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Get the aliases and functions
[[ -f ~/.bashrc ]]     && . ~/.bashrc
[[ -f ~/.bash_local ]] && . ~/.bash_local
