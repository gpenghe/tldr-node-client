#!/bin/bash

function older_than_one_day() {
  file_time=$(date -r "$1" +%s)
  one_day_ago=$(date -d 'now - 1 day' +%s)
  if [[ $file_time -lt $one_day_ago ]]; then
      return 0
  else
      return 1
  fi
}

function rebuild_command_list_cache() {
  cache=$1
  tldr="$HOME/github/tldr-node-client/bin/tldr"
  sheets=$($tldr -l -1)
  echo $sheets > $cache
}

function _tldr_autocomplete {
  cache="$HOME/.tldr.list.cache"
  if ! [[ -f $cache ]] || (older_than_one_day $cache) ; then
    rebuild_command_list_cache $cache
  fi
  sheets=$(cat $cache)
  COMPREPLY=()
  if [ $COMP_CWORD = 1 ]; then
    COMPREPLY=(`compgen -W "$sheets" -- $2`)
  fi
}

complete -F _tldr_autocomplete tldr
