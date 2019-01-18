source $HOME/.zplug/init.zsh

# zsh package
zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:0
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# command
zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "b4b4r07/zsh-gomi", as:command, use:bin/gomi, on:junegunn/fzf-bin
zplug "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2

# environment
zplug "lukechilds/zsh-nvm"
zplug "b4b4r07/enhancd", use:init.sh, on:junegunn/fzf-bin

# theme and prompt
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

if ! zplug check; then
  zplug install
fi

zplug load

autoload -Uz compinit; compinit
autoload -Uz colors; colors

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000

setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt auto_menu
setopt list_packed
setopt list_types
setopt pushd_ignore_dups
setopt share_history
setopt correct
setopt magic_equal_subst
setopt complete_aliases
setopt extended_glob
setopt nonomatch
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

unsetopt caseglob
unsetopt promptcr

# fzf: history search
function history-fzf() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

# fzf: ghq search
function cd-fzf-ghqlist() {
  local GHQ_ROOT=`ghq root`
  local REPO=`ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' | fzf +m`
  if [ -n "${REPO}" ]; then
    BUFFER="cd ${GHQ_ROOT}/${REPO}"
  fi
  zle accept-line
}
zle -N cd-fzf-ghqlist
bindkey '^g' cd-fzf-ghqlist

# fzf: git change branch
function checkout-fzf-gitbranch() {
  local GIT_BRANCH=$(git branch --all | grep -v HEAD | fzf --ansi +m)
  if [ -n "$GIT_BRANCH" ]; then
    git checkout $(echo "$GIT_BRANCH" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  fi
  zle accept-line
}
zle -N checkout-fzf-gitbranch
bindkey '^o' checkout-fzf-gitbranch

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Poetry
export PATH="$PATH:$HOME/.poetry/bin"
fpath+=~/.zfunc

# exa as ls
if [[ -x `which exa` ]]; then
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF"
  alias lla="exa -bhlHFa"
else
  case ${OSTYPE} in
    darwin*)
      alias ls="ls -GF"
      ;;
    linux*)
      alias ls="ls -F --color=auto"
      ;;
  esac
  alias la="ls -A"
  alias ll="ls -l"
  alias lla="ls -lA"
fi

# git alias
alias g="git"
alias gs="git s"
alias gl="git l"
alias gb="git b"
alias ga="git a"
alias gd="git d"
alias gn="git new"
alias gcm="git cm"
alias gco="git co"

# gomi-cli alias
alias rm="gomi"
