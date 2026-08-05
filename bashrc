# .bashrc

case $- in
  *i*) ;;
  *) return ;;
esac

[[ -r /etc/bashrc ]] && . /etc/bashrc

bashrc_source=${BASH_SOURCE[0]}
while [[ -L $bashrc_source ]]; do
  bashrc_dir=$(cd "$(dirname "$bashrc_source")" >/dev/null 2>&1 && pwd -P)
  bashrc_target=$(readlink "$bashrc_source")
  [[ $bashrc_target == /* ]] || bashrc_target="$bashrc_dir/$bashrc_target"
  bashrc_source=$bashrc_target
done
bashrc_dir=$(cd "$(dirname "$bashrc_source")" >/dev/null 2>&1 && pwd -P)

for file in "$bashrc_dir"/bash.d/[0-8]*.bash "$HOME"/.bash.d/*.sh "$bashrc_dir"/bash.d/9*.bash; do
  [[ -r $file ]] || continue
  [[ ${file##*/} == 00-path.bash ]] && continue
  [[ ${file##*/} == ssh-agent.sh ]] && continue
  [[ ${file##*/} == ssh-agent-sock.sh ]] && continue
  . "$file"
done

[[ -r "$HOME/.bash.d/local.bash" ]] && . "$HOME/.bash.d/local.bash"

unset bashrc_source bashrc_dir bashrc_target file
