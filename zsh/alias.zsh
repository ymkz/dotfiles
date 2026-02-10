alias cd-="cd -"
alias cds="cd ~/work"
alias cds="cd ~/sandbox"

alias deps="cat package.json | jq -r '.dependencies | keys[]' | tr '\n' ' '"
alias devdeps="cat package.json | jq -r '.devDependencies | keys[]' | tr '\n' ' '"

if type gat > /dev/null; then
  alias cat="gat"
fi

if type npm > /dev/null; then
  alias ng="npm ls --location=global --depth=0"
fi

if type eza > /dev/null; then
  alias l="eza"
  alias ls="eza"
  alias la="eza -A"
  alias lt="eza --tree --level 1"
  alias ll="eza -Hlo --no-user --sort=type --time-style=long-iso"
  alias lla="eza -HAlo --no-user --sort=type --time-style=long-iso"
else
  alias l="ls -hFG"
  alias ls="ls -hFG"
  alias la="ls -hA"
  alias ll="ls -hl"
  alias lla="ls -hAlF"
fi

if type code > /dev/null; then
  alias code.="code ."
  alias coder="code . --reuse-window"
  alias codeextensions="code --list-extensions | xargs -L 1 echo code --install-extension"
fi

if type git > /dev/null; then
  alias gpl="git pull"
  alias gps="git push"
  alias gf="git fetch"
  alias gs="git status --short --branch"
  alias gl="git log -n 10 --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
  alias gll="git log --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
  alias gb="git branch"
  alias gbl="git branch -a -vv"
  alias ga="git add"
  alias ga.="git add ."
  alias gd="git diff"
  alias gdc="git diff --cached"
  alias gdw="git diff --color-words"
  alias gds="git diff --color-words --word-diff-regex='\\\w+|[^[:space:]]'"
  alias gnew="git switch --create"
  alias grs="git restore"
  alias gun="git reset HEAD"
  alias gcm="git commit --message"
  alias gini="git commit --allow-empty -m 'chore: initial empty commit'"
  alias gam="git commit --amend -C HEAD"
  alias grecm="git commit --amend -m"
  alias gg="git fetch --all --prune; git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -D"
fi

if type clip.exe > /dev/null 2>&1; then
  alias pbcopy="clip.exe"
fi

if type powershell.exe > /dev/null 2>&1; then
  alias pbpaste="powershell.exe -command 'Get-Clipboard'"
fi
