#!/usr/bin/env bash

is_stable() {
  grep -E ' 0 (0|.* 0$)'
}

is_valid() {
  grep -v '-'
}

mutate() {
  awk '{print $1" "$2-1" "$3-1" "$4+1"\n"$1" "$2-1" "$3+1" "$4-1"\n"$1" "$2+1" "$3-1" "$4-1}' | \
    is_valid | sort -u
}

solve() {
  tmp="$(cat)"

  while [ -n "$tmp" ] && ! echo "$tmp" | is_stable; do
    tmp="$(echo "$tmp" | mutate)"
    # echo "$tmp"
  done
}

# echo "Forest $1 $2 $3"
echo "Forest $1 $2 $3" | solve
