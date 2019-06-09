# search

if [[ -x `which peco 2> /dev/null` && -x `which rg 2> /dev/null` ]]; then
  function fs () {
    local args=$@
    [[ $# -eq 0 ]] && args='.'

    eval $(rg -n $args | peco --layout=bottom-up | awk -F : "{print \"$EDITOR -c \" \$2 \" \" \$1}")
  }
fi

# pekill

if [[ -x `which peco 2> /dev/null` ]]; then
  function pekill () {
    ps -ef | peco --layout=bottom-up | awk '{ print $2 }' | xargs kill
  }
fi

# notes

if [[ -x `which peco 2> /dev/null` && -x `which ag 2> /dev/null` ]]; then
  function notes () {
    eval $(ag -U $@ $HOME/notes | peco --layout=bottom-up | awk -F : "{print \"$EDITOR -c \" \$2 \" \" \$1}")
  }
fi

