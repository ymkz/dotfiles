#!/usr/bin/env bash

set -eu

# setup dir
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.cache"
mkdir -p "${HOME}/.local/share"
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

# fetch dotfiles
if [[ ! -e "${HOME}/work/github.com/ymkz/dotfiles" ]]; then
  git clone https://github.com/ymkz/dotfiles.git "${HOME}/work/github.com/ymkz/dotfiles"
fi

# setup linux on wsl
if [[ "${OSTYPE}" == linux* ]]; then
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential language-pack-ja procps curl wget git zip unzip zsh sqlite3
  sudo unlink /etc/resolv.conf
  sudo cp "${HOME}/work/github.com/ymkz/dotfiles/wsl/wsl.conf" "/etc/wsl.conf"
  sudo cp "${HOME}/work/github.com/ymkz/dotfiles/wsl/resolv.conf" "/etc/resolv.conf"
  sudo chattr +i /etc/resolv.conf
fi

# fetch zsh plugins
if [[ ! -e "${HOME}/.local/share/zsh" ]]; then
  mkdir -p "${HOME}/.local/share/zsh"
  git clone https://github.com/sindresorhus/pure "${HOME}/.local/share/zsh/pure"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.local/share/zsh/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.local/share/zsh/zsh-syntax-highlighting"
fi

# deploy dotfiles
if [[ -e "${HOME}/work/github.com/ymkz/dotfiles" ]]; then
  mkdir -p "${HOME}/.config/git"
  mkdir -p "${HOME}/.config/zsh"
  mkdir -p "${HOME}/.config/mise"
  mkdir -p "${HOME}/.config/atuin"
  mkdir -p "${HOME}/.claude"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/misc/editorconfig" "${HOME}/.editorconfig"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/node/npmrc" "${HOME}/.npmrc"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/vim/vimrc" "${HOME}/.vimrc"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/zsh/zshrc" "${HOME}/.zshrc"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/zsh/alias.zsh" "${HOME}/.config/zsh/alias.zsh"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/zsh/function.zsh" "${HOME}/.config/zsh/function.zsh"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/git/config" "${HOME}/.config/git/config"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/git/ignore" "${HOME}/.config/git/ignore"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/mise/config.toml" "${HOME}/.config/mise/config.toml"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/claude/settings.json" "${HOME}/.claude/settings.json"
  ln -nfs "${HOME}/work/github.com/ymkz/dotfiles/claude/commands" "${HOME}/.claude/commands"
fi

# install mise (https://mise.jdx.dev/installing-mise.html)
if ! type mise > /dev/null 2>&1; then
  curl https://mise.run | sh
  eval "$($HOME/.local/bin/mise activate)"
  mise install
fi

# change default shell
if type zsh > /dev/null 2>&1; then
  which zsh | sudo tee -a /etc/shells
  sudo chsh "${USER}" -s "$(which zsh)"
fi
