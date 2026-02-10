function repo() {
  local root
  local repository

  ghq_root=$(ghq root)
  repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="repository > ")

  if [[ -n "$repository" ]]; then
    BUFFER="cd ${ghq_root}/${repository}"
    zle accept-line
  fi

  zle reset-prompt
}


zle -N repo
bindkey '^g' repo

function br() {
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
    BUFFER="git switch '${branch}'"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N br
bindkey '^b' br

function wt() {
  git wt "$(git wt | tail -n +2 | fzf | awk '{print $(NF-1)}')"
}

zle -N wt
bindkey '^t' wt
