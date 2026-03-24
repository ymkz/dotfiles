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
  commit_message=$(opencode --print "Review the contents of git diff --cached and generate a commit message in the Conventional Commit format. The output should be plain text only; Markdown code blocks should not be used.")
  if [[ -n "$commit_message" ]]; then
    git commit -m "$commit_message" -e
  fi
}
