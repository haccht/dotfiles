[[ -t 1 ]] || return

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

prompt_host_color() {
  printf '%s' "${prompt_theme_colors[$(prompt_hash_index)]}"
}

PROMPT_HOST_COLOR=$(prompt_host_color)
PROMPT_PATH_COLOR=250
PROMPT_SSH_COLOR=45
PROMPT_ROOT_COLOR=196

PROMPT_HOST_STYLE="\[\e[38;5;${PROMPT_HOST_COLOR}m\]"
PROMPT_PATH_STYLE="\[\e[38;5;${PROMPT_PATH_COLOR}m\]"
PROMPT_SSH_STYLE="\[\e[38;5;${PROMPT_SSH_COLOR}m\]"
PROMPT_ROOT_STYLE="\[\e[38;5;${PROMPT_ROOT_COLOR}m\]"
PROMPT_RESET="\[\e[0m\]"

prompt_cmd() {
  local status=$? status_symbol git_ps1 ssh_label title

  status_symbol="${PROMPT_RESET}$"
  if [[ $EUID -eq 0 ]]; then
    status_symbol="${PROMPT_ROOT_STYLE}#${PROMPT_RESET}"
  elif [[ $status -ne 0 ]]; then
    status_symbol="${PROMPT_ROOT_STYLE}$${PROMPT_RESET}"
  fi

  history -a
  history -n

  git_ps1=
  if (( PROMPT_HAS_GIT_PS1 )) && declare -F __git_ps1 >/dev/null 2>&1; then
    git_ps1="$(__git_ps1)"
  fi

  ssh_label=
  if [[ -n ${SSH_CONNECTION:-}${SSH_TTY:-} ]]; then
    ssh_label="${PROMPT_SSH_STYLE}[SSH]${PROMPT_RESET} "
  fi

  title="\u@\h:\w"
  case $TERM in
    xterm*|rxvt*|tmux*|screen*)
      printf '\033]0;%s\007' "$title"
      PS1="\n${ssh_label}${PROMPT_HOST_STYLE}\u@\h ${PROMPT_PATH_STYLE}\w${git_ps1}\n${status_symbol} "
      ;;
  esac
}

PROMPT_COMMAND=prompt_cmd
export -n PROMPT_COMMAND 2>/dev/null || true
