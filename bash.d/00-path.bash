path_prepend() {
  local dir part new_path old_ifs

  for dir in "$@"; do
    [[ -d $dir ]] || continue

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

    path_prepend "$brew_prefix/bin" "$brew_prefix/sbin"

    path_prepend "$brew_prefix/opt/curl/bin"
    path_prepend "$brew_prefix/opt/coreutils/libexec/gnubin"

    export GOROOT="$brew_prefix/opt/go/libexec"
  fi

  path_prepend /Applications/Obsidian.app/Contents/MacOS
fi

path_prepend "$HOME/bin" "$HOME/.local/bin" "$GOPATH/bin" "$GOROOT/bin"

if [[ -d $HOME/.rbenv/bin ]]; then
  path_prepend "$HOME/.rbenv/bin"
  command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init --no-rehash -)"
fi

path_dedupe
