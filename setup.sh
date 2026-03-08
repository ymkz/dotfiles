#!/usr/bin/env bash

set -euo pipefail

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="${HOME}/.config"}
XDG_CACHE_HOME=${XDG_CACHE_HOME:="${HOME}/.cache"}
XDG_DATA_HOME=${XDG_DATA_HOME:="${HOME}/.local/share"}
XDG_STATE_HOME=${XDG_STATE_HOME:="${HOME}/.local/state"}
DOTFILES_DIR=${DOTFILES_DIR:="${HOME}/work/github.com/ymkz/dotfiles"}

# setup dir
mkdir -p "${XDG_CONFIG_HOME}"
mkdir -p "${XDG_CACHE_HOME}"
mkdir -p "${XDG_DATA_HOME}"
mkdir -p "${XDG_STATE_HOME}"
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

# fetch dotfiles
if [[ ! -e "${DOTFILES_DIR}" ]]; then
  git clone https://github.com/ymkz/dotfiles.git "${DOTFILES_DIR}"
fi

# setup linux on wsl
if [[ "${OSTYPE}" == linux* ]]; then
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential language-pack-ja procps curl wget git zip unzip zsh sqlite3
  sudo unlink /etc/resolv.conf
  sudo cp "${DOTFILES_DIR}/wsl/wsl.conf" "/etc/wsl.conf"
  sudo cp "${DOTFILES_DIR}/wsl/resolv.conf" "/etc/resolv.conf"
  sudo chattr +i /etc/resolv.conf
fi

# fetch zsh plugins
if [[ ! -e "${HOME}/.local/share/zsh" ]]; then
  mkdir -p "${HOME}/.local/share/zsh"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.local/share/zsh/zsh-autosuggestions"
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "${HOME}/.local/share/zsh/fast-syntax-highlighting"
  git clone https://github.com/yuki-yano/zeno.zsh "${HOME}/.local/share/zsh/zeno"
fi

# deploy dotfiles
if [[ -e "${DOTFILES_DIR}" ]]; then
  ln -nfs "${DOTFILES_DIR}/misc/editorconfig" "${HOME}/.editorconfig"
  ln -nfs "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"
  ln -nfs "${DOTFILES_DIR}/vim/vimrc" "${HOME}/.vimrc"
  ln -nfs "${DOTFILES_DIR}/node/npmrc" "${HOME}/.npmrc"

  ln -nfs "${DOTFILES_DIR}/starship/starship.toml" "${XDG_CONFIG_HOME}/starship.toml"

  mkdir -p "${XDG_CONFIG_HOME}/zeno"
  ln -nfs "${DOTFILES_DIR}/zeno/config.yaml" "${XDG_CONFIG_HOME}/zeno/config.yaml"

  mkdir -p "${XDG_CONFIG_HOME}/git"
  ln -nfs "${DOTFILES_DIR}/git/config" "${XDG_CONFIG_HOME}/git/config"
  ln -nfs "${DOTFILES_DIR}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"

  mkdir -p "${XDG_CONFIG_HOME}/mise"
  ln -nfs "${DOTFILES_DIR}/mise/config.toml" "${XDG_CONFIG_HOME}/mise/config.toml"

  mkdir -p "${XDG_CONFIG_HOME}/opencode"
  ln -nfs "${DOTFILES_DIR}/opencode/opencode.jsonc" "${XDG_CONFIG_HOME}/opencode/opencode.jsonc"
  ln -nfs "${DOTFILES_DIR}/opencode/oh-my-opencode.jsonc" "${XDG_CONFIG_HOME}/opencode/oh-my-opencode.jsonc"
fi

# install rust (https://www.rust-lang.org/ja/tools/install)
if ! type rustup > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  rustup --version
fi

# install mise (https://mise.jdx.dev/installing-mise.html)
if ! type mise > /dev/null 2>&1; then
  curl https://mise.run | sh
  eval "$($HOME/.local/bin/mise activate)"
  mise --version
  mise install
fi

# change default shell
if type zsh > /dev/null 2>&1; then
  which zsh | sudo tee -a /etc/shells
  sudo chsh "${USER}" -s "$(which zsh)"
fi
