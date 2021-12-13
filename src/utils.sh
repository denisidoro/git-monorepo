#!/usr/bin/env bash
set -euo pipefail

CALL_DIR="$(pwd)"
TMP_DIR="/tmp/gitmonorepo"
CFG_FILE="${CALL_DIR}/.gitmonorepo"

echoerr() {
   echo "$@" >&2
}

expand_tilde() {
   local -r x="$(cat)"
   echo "${x//\~/$HOME}"
}

trim() {
   local str="$1"
   if [[ $str =~ ^[[:space:]]*(|[^[:space:]]|[^[:space:]].*[^[:space:]])[[:space:]]*$ ]]; then
      str="${BASH_REMATCH[1]}"
   fi
   echo "$str"
}

call_cmd() {
   local -r cmd="$1"
   shift || true
   source "${GIT_MONOREPO_PATH}/src/${cmd}.sh"
   set -x
   $cmd "$@"
}

subtree() {
   local -r dir="$1"
   local -r remote="$2"
   local -r branch="$3"

   cd "$CALL_DIR"

   git subtree split -P "$dir" -b "$branch"
   mkdir -p "$remote" || true

   cd "$remote"
   git init
   git pull "$CALL_DIR" "$branch"
}