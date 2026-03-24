#!/usr/bin/env bash

set -euo pipefail

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="${HOME}/.config"}
XDG_CACHE_HOME=${XDG_CACHE_HOME:="${HOME}/.cache"}
XDG_DATA_HOME=${XDG_DATA_HOME:="${HOME}/.local/share"}
XDG_STATE_HOME=${XDG_STATE_HOME:="${HOME}/.local/state"}
DOTFILES_DIR=${DOTFILES_DIR:="${HOME}/work/github.com/ymkz/dotfiles"}

### setup dir
mkdir -p "${XDG_CONFIG_HOME}"
mkdir -p "${XDG_CACHE_HOME}"
mkdir -p "${XDG_DATA_HOME}"
mkdir -p "${XDG_STATE_HOME}"
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

### fetch dotfiles
git clone https://github.com/ymkz/dotfiles.git "${DOTFILES_DIR}"

### setup linux on wsl
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential language-pack-ja procps curl wget git zip unzip zsh sqlite3
sudo unlink /etc/resolv.conf
sudo cp "${DOTFILES_DIR}/wsl/wsl.conf" "/etc/wsl.conf"
sudo cp "${DOTFILES_DIR}/wsl/resolv.conf" "/etc/resolv.conf"
sudo chattr +i /etc/resolv.conf

### fetch zsh plugins
mkdir -p "${XDG_DATA_HOME}/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${XDG_DATA_HOME}/zsh/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${XDG_DATA_HOME}/zsh/zsh-autosuggestions"
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting "${XDG_DATA_HOME}/zsh/fast-syntax-highlighting"

### deploy dotfiles
ln -nfs "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"
ln -nfs "${DOTFILES_DIR}/vim/vimrc" "${HOME}/.vimrc"
ln -nfs "${DOTFILES_DIR}/node/npmrc" "${HOME}/.npmrc"
ln -nfs "${DOTFILES_DIR}/misc/editorconfig" "${HOME}/.editorconfig"

mkdir -p "${XDG_CONFIG_HOME}/zsh"
ln -nfs "${DOTFILES_DIR}/zsh/p10k.zsh" "${XDG_CONFIG_HOME}/zsh/p10k.zsh"
ln -nfs "${DOTFILES_DIR}/zsh/alias.zsh" "${XDG_CONFIG_HOME}/zsh/alias.zsh"
ln -nfs "${DOTFILES_DIR}/zsh/function.zsh" "${XDG_CONFIG_HOME}/zsh/function.zsh"

mkdir -p "${XDG_CONFIG_HOME}/git"
ln -nfs "${DOTFILES_DIR}/git/config" "${XDG_CONFIG_HOME}/git/config"
ln -nfs "${DOTFILES_DIR}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"

mkdir -p "${XDG_CONFIG_HOME}/mise"
ln -nfs "${DOTFILES_DIR}/mise/config.toml" "${XDG_CONFIG_HOME}/mise/config.toml"

mkdir -p "${XDG_CONFIG_HOME}/atuin"
ln -nfs "${DOTFILES_DIR}/atuin/config.toml" "${XDG_CONFIG_HOME}/atuin/config.toml"

mkdir -p "${XDG_CONFIG_HOME}/opencode"
ln -nfs "${DOTFILES_DIR}/opencode/opencode.jsonc" "${XDG_CONFIG_HOME}/opencode/opencode.jsonc"
# ln -nfs "${DOTFILES_DIR}/opencode/oh-my-opencode.jsonc" "${XDG_CONFIG_HOME}/opencode/oh-my-opencode.jsonc"

### install rust (https://www.rust-lang.org/ja/tools/install)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup --version

### install mise (https://mise.jdx.dev/installing-mise.html)
curl https://mise.run | sh
eval "$($HOME/.local/bin/mise activate)"
mise --version
mise install

### change default shell
which zsh | sudo tee -a /etc/shells
sudo chsh "${USER}" -s "$(which zsh)"
