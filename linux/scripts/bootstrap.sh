#!/usr/bin/env bash

set -eu

if [ -e "$HOME/workspace/ghq/github.com/ymkz/dotfiles" ]; then
  echo >&2 "Quit bootstrap because dotfiles already exist."
  exit 1
fi

echo ">>> Update user directories name to English"
LANG=C xdg-user-dirs-gtk-update

# updatedbの無効化(locateコマンド使わないなら絶対しておくべき)
# もとに戻すなら `sudo chmod 755 /etc/cron.daily/mlocate`
sudo chmod 644 /etc/cron.daily/mlocate

echo ">>> Install system from apt"
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
sudo apt install -y \
  automake \
  autoconf \
  apt-transport-https \
  build-essential \
  libreadline-dev \
  libncurses-dev \
  libssl-dev \
  libyaml-dev \
  libxslt-dev \
  libffi-dev \
  libtool \
  unixodbc-dev \
  unzip \
  curl \
  file \
  git \
  exa \
  fzf \
  zsh

echo ">>> Install linuxbrew"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

echo ">>> Activate linuxbrew for temporarily"
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

echo ">>> Install system from linuxbrew"
brew install ghq
brew install starship

echo ">>> Install zplug"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo ">>> Install volta"
curl https://get.volta.sh | bash

echo ">>> Fetch dotfiles"
mkdir -p $HOME/workspace/ghq/github.com/ymkz
git clone https://github.com/ymkz/dotfiles.git $HOME/workspace/ghq/github.com/ymkz/dotfiles

echo ">>> Link dotfiles"
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/starship.toml $HOME/.config/starship.toml
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/vimrc $HOME/.vimrc
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/ymkz/dotfiles/linux/zshrc $HOME/.zshrc

# reference: UbuntuにVSCodeをインストールする3つの方法 - https://qiita.com/yoshiyasu1111/items/e21a77ed68b52cb5f7c8
echo ">>> Install VSCode"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $HOME/microsoft.gpg
sudo install -o root -g root -m 644 $HOME/microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update -y
sudo apt install code -y
rm $HOME/microsoft.gpg

echo ">>> Change default shell"
sudo chsh $USER -s $(which zsh)

echo ">>> ---"
echo ">>> Done!"
echo ">>> Please restart computer to activate brand new environment."
