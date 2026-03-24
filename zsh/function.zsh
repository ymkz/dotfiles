function fzf_ghq_repository() {
  local root
  local repository
  ghq_root=$(ghq root)
  repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="Repository > ")
  if [[ -n "$repository" ]]; then
    BUFFER="cd ${ghq_root}/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_ghq_repository
bindkey '^g' fzf_ghq_repository

function fzf_git_branch() {
  local branch
  local current_branch
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes \
    | grep -x -v 'origin' \
    | sed 's/origin\///' \
    | awk '!a[$1]++' \
    | grep -x -v "$current_branch" \
    | fzf +m --query="$LBUFFER" --prompt="Branch > ")
  if [[ -n "$branch" ]]; then
    BUFFER="git switch '${branch}'"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_git_branch
bindkey '^b' fzf_git_branch

function gca() {
  local commit_message
  commit_message=$(pi --print 'Generate Conventional Commit from staged changes. Rules: 1) Format: type(scope): summary, blank line, body explaining what and why. 2) Use imperative mood. 3) Output ONLY the commit message as plain text, never use markdown code blocks.')
  if [[ -n "$commit_message" ]]; then
    git commit -m "$commit_message" -e
  fi
}
