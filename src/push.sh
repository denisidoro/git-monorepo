#!/usr/bin/env bash

# TODO: avoid reconstructing repository
push_one() {
   local -r dir="$(trim "$1")"
   local -r remote="$(trim "$2" | expand_tilde)"
   local -r branch="gitmonorepo/push/${dir}"

   rm -rf "$remote"
   subtree "$dir" "$remote" "$branch"
}

# TODO: only execute logic for necessary repositories
push() {
   cd "$CALL_DIR"

   while read -r line; do
      parts=(${line//:/ })
      push_one "${parts[0]}" "${parts[1]}" || true
   done < "$CFG_FILE"
}
