#!/usr/bin/env bash

extract() {
   local -r dir="$1"
   local -r remote="$2"
   local -r branch="gitmonorepo/extract/${dir}"

   local -r short_remote="${remote//${HOME}/'~'}"

   subtree "$dir" "$remote" "$branch"

   cd "$CALL_DIR"
   git branch -D "$branch"
   touch "$CFG_FILE" || true
   echo "${dir}: ${short_remote}" >> "$CFG_FILE"

   git add .
   git commit -am "Extract ${dir}"

   tree "$remote"
}
