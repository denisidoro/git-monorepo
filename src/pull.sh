#!/usr/bin/env bash

# TODO: make git log cleaner
# TODO: avoid full git clone
pull_one() {
   local -r branch="$1"
   local -r dir="$(trim "$2")"
   local -r remote="$(trim "$3" | expand_tilde)"
   local -r tmp_proj="${TMP_DIR}/${dir}"

   local -r tmp_origin="gitmonorepo/${dir}"

   cd "$TMP_DIR"
   git clone -b "$branch" "$remote"

   cd "$dir"
   git filter-repo --to-subdirectory-filter "$dir" --force
   tree .
   git log

   cd "$CALL_DIR"
   git remote add "$tmp_origin" "$tmp_proj"
   git fetch "$tmp_origin"
   git merge --allow-unrelated-histories "${tmp_origin}/${branch}" -X theirs
   git remote remove "$tmp_origin"
}

# TODO: only execute logic for necessary repositories
pull() {
   local -r branch="$1"

   cd "$CALL_DIR"
   git checkout -b "$branch"

   mkdir -p "${TMP_DIR}"

   while read -r line; do
      parts=(${line//:/ })
      pull_one "$branch" "${parts[0]}" "${parts[1]}" || true
   done < "$CFG_FILE"
}
