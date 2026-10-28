# .bashrc

# ---------------------------------------------------------------------------
# 1. PATH & Runtime Environments (runs in both login and interactive shells)
# ---------------------------------------------------------------------------
path_prepend() {
  local check_exists=1
  if [[ ${1:-} == --force ]]; then
    check_exists=0
    shift
  fi

  local dir part new_path old_ifs
  local -a dirs=("$@")
  local i

  for (( i = ${#dirs[@]} - 1; i >= 0; i-- )); do
    dir=${dirs[i]}
    [[ -n $dir ]] || continue
    if (( check_exists )) && [[ ! -d $dir ]]; then
      continue
    fi

    new_path=
    old_ifs=$IFS
    IFS=:
    for part in $PATH; do
      [[ $part == "$dir" ]] && continue
      new_path="${new_path:+$new_path:}$part"
    done
    IFS=$old_ifs

    PATH="$dir${new_path:+:$new_path}"
  done

  export PATH
}

path_dedupe() {
  local part new_path old_ifs

  new_path=
  old_ifs=$IFS
  IFS=:
  for part in $PATH; do
    [[ -n $part ]] || continue
    case ":$new_path:" in
      *":$part:"*) ;;
      *) new_path="${new_path:+$new_path:}$part" ;;
    esac
  done
  IFS=$old_ifs

  PATH=$new_path
  export PATH
}

export GO111MODULE=on
export GOPATH="${GOPATH:-$HOME}"
export GOROOT="${GOROOT:-/usr/local/go}"
export GHQ_ROOT="${GHQ_ROOT:-$GOPATH/src}"

if [[ $OSTYPE == darwin* ]]; then
  if [[ -d /opt/homebrew ]]; then
    brew_prefix=/opt/homebrew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_prefix=/usr/local
  elif command -v brew >/dev/null 2>&1; then
    brew_prefix="$(brew --prefix)"
  else
    brew_prefix=
  fi

  if [[ -n $brew_prefix ]]; then
    export HOMEBREW_PREFIX="$brew_prefix"
    export HOMEBREW_CELLAR="$brew_prefix/Cellar"
    export HOMEBREW_REPOSITORY="$brew_prefix"

    path_prepend \
      "$brew_prefix/opt/coreutils/libexec/gnubin" \
      "$brew_prefix/opt/curl/bin" \
      "$brew_prefix/bin" \
      "$brew_prefix/sbin"

    export GOROOT="$brew_prefix/opt/go/libexec"
  fi

  path_prepend /Applications/Obsidian.app/Contents/MacOS
  unset brew_prefix
fi

path_prepend "$GOPATH/bin" "$GOROOT/bin"
path_prepend --force "$HOME/.local/bin" "$HOME/bin"

if [[ -d $HOME/.rbenv/bin ]]; then
  path_prepend "$HOME/.rbenv/bin"
  command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init --no-rehash -)"
fi

path_dedupe

# ---------------------------------------------------------------------------
# 2. Interactive Shell Guard
# ---------------------------------------------------------------------------
case $- in
  *i*) ;;
  *) return ;;
esac

# ---------------------------------------------------------------------------
# 3. System Bashrc & Bash Completion
# ---------------------------------------------------------------------------
if [[ -r /etc/bashrc ]]; then
  . /etc/bashrc
elif [[ -r /etc/bash.bashrc ]]; then
  . /etc/bash.bashrc
fi

if ! shopt -oq posix && [[ -z ${BASH_COMPLETION_VERSINFO:-} ]]; then
  if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -r /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# ---------------------------------------------------------------------------
# 4. History & Shell Options
# ---------------------------------------------------------------------------
shopt -s histappend cmdhist lithist checkwinsize

export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%F %T '
export HISTIGNORE='ls:ll:la:cd:cd -:pwd:exit:history'

# ---------------------------------------------------------------------------
# 5. Aliases & OS / WSL Adjustments
# ---------------------------------------------------------------------------
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias grep='grep --color=auto'

if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls -F --color=auto'
else
  alias ls='ls -F'
fi

if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi

if [[ $OSTYPE == linux* ]] && { [[ -n ${WSL_DISTRO_NAME:-} ]] || [[ -r /proc/version && $(< /proc/version) == *[Mm]icrosoft* ]]; }; then
  umask 022
  alias pbcopy='clip.exe'
fi

# ---------------------------------------------------------------------------
# 6. Interactive Functions & Keybindings
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  _edit_wo_executing() {
    local tmpf
    tmpf="$(mktemp)" || return

    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    "${EDITOR:-vi}" "$tmpf" || {
      rm -f "$tmpf"
      return
    }

    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="${#READLINE_LINE}"
    rm -f "$tmpf"
  }
  bind -x '"\C-x\C-e":_edit_wo_executing'
fi

[[ -r "$HOME/.fzf.bash" ]] && . "$HOME/.fzf.bash"

if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1 && [[ -t 1 ]]; then
  repo() {
    local selected
    selected="$(ghq list | sort | fzf --no-sort --cycle --query "${*:-}" --prompt='Repository > ')"
    [[ -n $selected ]] && cd "$GHQ_ROOT/$selected"
  }
fi

# ---------------------------------------------------------------------------
# 7. Extra Drop-in Scripts (~/.bash.d/*.sh, ~/.bash.d/*.bash)
#    (e.g., git-prompt.sh, ssh-agent.sh, ssh-agent-sock.sh, local.bash)
# ---------------------------------------------------------------------------
for _bashd_file in "$HOME"/.bash.d/*.sh "$HOME"/.bash.d/*.bash; do
  [[ -r $_bashd_file ]] && . "$_bashd_file"
done
unset _bashd_file

# ---------------------------------------------------------------------------
# 8. Prompt
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  PROMPT_HAS_GIT_PS1=1
  GIT_PS1_SHOWDIRTYSTATE=1

  prompt_host=${HOSTNAME:-$(hostname)}
  prompt_theme_colors=(34 202 216 39 165 243 214 33 37 41 45 51 75 81 111 117 141 147 171 177 203 209 215 220 227)

  prompt_hash_index() {
    local hash
    if command -v cksum >/dev/null 2>&1; then
      hash=$(printf '%s' "$prompt_host" | cksum)
      hash=${hash%% *}
    else
      hash=${#prompt_host}
    fi
    printf '%s\n' "$((hash % ${#prompt_theme_colors[@]}))"
  }

  PROMPT_HOST_COLOR="${prompt_theme_colors[$(prompt_hash_index)]}"
  PROMPT_PATH_COLOR=250
  PROMPT_ROOT_COLOR=196

  PROMPT_HOST_STYLE="\[\e[38;5;${PROMPT_HOST_COLOR}m\]"
  PROMPT_PATH_STYLE="\[\e[38;5;${PROMPT_PATH_COLOR}m\]"
  PROMPT_ROOT_STYLE="\[\e[38;5;${PROMPT_ROOT_COLOR}m\]"
  PROMPT_RESET="\[\e[0m\]"

  prompt_cmd() {
    local status=$? status_symbol git_ps1 title title_host title_path

    status_symbol="${PROMPT_RESET}\$"
    if [[ $EUID -eq 0 ]]; then
      status_symbol="${PROMPT_ROOT_STYLE}#${PROMPT_RESET}"
    elif [[ $status -ne 0 ]]; then
      status_symbol="${PROMPT_ROOT_STYLE}\$${PROMPT_RESET}"
    fi

    history -a
    history -n

    git_ps1=
    if (( PROMPT_HAS_GIT_PS1 )) && declare -F __git_ps1 >/dev/null 2>&1; then
      git_ps1="$(__git_ps1)"
    fi

    title_host=${HOSTNAME:-$(hostname)}
    title_host=${title_host%%.*}
    case $PWD in
      "$HOME")   title_path=\~ ;;
      "$HOME"/*) title_path=\~/${PWD#"$HOME"/} ;;
      *)         title_path=$PWD ;;
    esac
    title="${USER:-$(id -un)}@${title_host}:${title_path}"
    case $TERM in
      xterm*|rxvt*|tmux*|screen*|*ghostty*|alacritty*|wezterm*)
        printf '\033]0;%s\007' "$title"
        ;;
    esac
    PS1="\n${PROMPT_HOST_STYLE}\u@\h ${PROMPT_PATH_STYLE}\w${git_ps1}\n${status_symbol} "
  }

  PROMPT_COMMAND=prompt_cmd
  export -n PROMPT_COMMAND 2>/dev/null || true
fi
