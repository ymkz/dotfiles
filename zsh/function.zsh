function repo() {
  local repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="repository > ")
  if [[ -n "$repository" ]]; then
    BUFFER="cd $(ghq root)/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}

function br() {
  local branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | grep -x -v 'origin' | sed 's/origin\///' | awk '!a[$1]++' | grep -x -v $(git symbolic-ref --short HEAD) | fzf +m --query="$LBUFFER" --prompt="branch > ")
  if [[ -n "$branch" ]]; then
    BUFFER="git switch '${branch}'"
    zle accept-line
  fi
  zle reset-prompt
}

function wt() {
  git wt "$(git wt | tail -n +2 | fzf | awk '{print $(NF-1)}')"
}
