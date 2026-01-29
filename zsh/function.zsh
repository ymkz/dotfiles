function repo() {
  local repository=$(ghq list | fzf +m --prompt="repository > ") || return
  cd "$(ghq root)/${repository}"
}

zle -N repo
bindkey '^g' repo

function br() {
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  local branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null \
    | grep -vF "origin" \
    | sed 's|^origin/||' \
    | awk '!seen[$0]++' \
    | grep -vxF "${current_branch}" \
    | fzf +m --prompt="branch > " 2>/dev/null) || return
  git switch "${branch}" 2>/dev/null
}

zle -N br
bindkey '^b' br

function wt() {
  git wt "$(git wt | tail -n +2 | fzf | awk '{print $(NF-1)}')"
}
