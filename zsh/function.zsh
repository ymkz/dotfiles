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

function gaic() {
  COMMIT_MSG=$(pi --model zai/glm-4.7 --print 'Generate ONLY a one-line Git commit message, using imperative mood, summarizing what was changed and why, based strictly on the contents of `git diff --cached`. DO NOT add an explanation or a body. Output ONLY the commit summary line.')
  git commit -m "$COMMIT_MSG" -e
}