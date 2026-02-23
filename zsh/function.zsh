function g() {
  local root
  local repository

  ghq_root=$(ghq root)
  repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="repository > ")

  if [[ -n "$repository" ]]; then
    cd "${ghq_root}/${repository}"
  fi
}

function b() {
  local branch
  local current_branch

  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes \
    | grep -x -v 'origin' \
    | sed 's/origin\///' \
    | awk '!a[$1]++' \
    | grep -x -v "$current_branch" \
    | fzf +m --query="$LBUFFER" --prompt="branch > ")

  if [[ -n "$branch" ]]; then
    git switch "${branch}"
  fi
}
