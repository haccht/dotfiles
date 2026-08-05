shopt -s histappend
shopt -s cmdhist
shopt -s lithist

export HISTTIMEFORMAT='%F %T '
export HISTIGNORE='ls:ll:la:cd:cd -:pwd:exit:history'

if [[ -t 1 ]]; then
  _edit_wo_executing() {
    local tmpf
    tmpf="$(mktemp)"
    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    "${EDITOR:-vi}" "$tmpf"
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
