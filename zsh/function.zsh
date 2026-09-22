function gess() {
  gat --force-color "$@" | less -R
}

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

function git_detach_branch_worktree() {
  local branch="${1:?Usage: git_detach_branch_worktree <branch> <target worktree>}"
  local target="${2:?Usage: git_detach_branch_worktree <branch> <target worktree>}"
  local worktree

  worktree=$(git -C "$target" worktree list --porcelain | awk -v ref="refs/heads/${branch}" '
    /^worktree / { path = substr($0, 10) }
    $0 == "branch " ref { print path; exit }
  ')

  if [[ -n "$worktree" && "$worktree" != "$target" ]]; then
    if [[ -n "$(git -C "$worktree" status --porcelain)" ]]; then
      print -u2 "Worktree has uncommitted changes: ${worktree}"
      return 1
    fi
    git -C "$worktree" switch --detach
  fi
}

function git_switch_branch() {
  local branch="${1:?Usage: git_switch_branch <branch> [start point]}"
  local start_point="${2:-}"
  local target

  target=$(git rev-parse --path-format=absolute --show-toplevel) || return
  git_detach_branch_worktree "$branch" "$target" || return

  if [[ -n "$start_point" ]]; then
    git switch --track -c "$branch" "$start_point"
  else
    git switch "$branch"
  fi
}

function fzf_git_branch() {
  local branch
  local current_branch
  local remote_branch
  local local_branch
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  branch=$(git for-each-ref --format='%(refname:lstrip=1) %(symref)' refs/heads refs/remotes \
    | awk 'NF == 1 {print $1}' \
    | grep -F -x -v -- "heads/${current_branch}" \
    | fzf +m --query="$LBUFFER" --prompt="Branch > ")
  if [[ -n "$branch" ]]; then
    if [[ "$branch" == heads/* ]]; then
      BUFFER="git_switch_branch '${branch#heads/}'"
    else
      remote_branch=${branch#remotes/}
      local_branch=${remote_branch#*/}
      if git show-ref --verify --quiet "refs/heads/${local_branch}"; then
        BUFFER="git_switch_branch '${local_branch}'"
      else
        BUFFER="git_switch_branch '${local_branch}' 'refs/remotes/${remote_branch}'"
      fi
    fi
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_git_branch
bindkey '^b' fzf_git_branch

function gh_pr_open_local() {
  local pr="${1:?Usage: gh_pr_open_local <PR number>}"
  local common_dir
  local local_root
  local branch

  common_dir=$(git rev-parse --path-format=absolute --git-common-dir) || return
  local_root=${common_dir:h}

  if [[ -n "$(git -C "$local_root" status --porcelain)" ]]; then
    print -u2 "Local checkout has uncommitted changes: ${local_root}"
    return 1
  fi

  branch=$(cd "$local_root" && gh pr view "$pr" --json headRefName --jq .headRefName) || return
  git_detach_branch_worktree "$branch" "$local_root" || return

  builtin cd "$local_root" || return
  gh pr checkout "$pr" || return
  edit .
}

function fzf_gh_pr_checkout() {
  local pr_num
  pr_num=$(gh pr list | column -s $'\t' -t | fzf +m --query="$LBUFFER" --prompt="PullRequest > " | awk '{print $1}')
  if [[ -n "$pr_num" ]]; then
    BUFFER="gh_pr_open_local ${pr_num}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_gh_pr_checkout
bindkey '^p' fzf_gh_pr_checkout
