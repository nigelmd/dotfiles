#!/bin/bash

# Update everything first
apt-get -y upgrade && apt-get -y update

# Install all the tools
apt-get -y install git
apt-get -y install aptitude
apt-get -y install silversearcher-ag
apt-get -y install zsh
apt-get -y install tmux
apt-get -y install vim
apt-get -y install vim-gnome

# Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp .vimrc ~/
cp .gvimrc ~/
mkdir -p ~/.vim/colors
cp plugins.vim ~/.vim
cp brogrammer.vim ~/.vim/colors

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .tmux.linux.conf ~/.tmux.conf

# If tmux isn't displaying symbols correctly
touch ~/.profile
echo "export LC_ALL=en_US.UTF-8" >> ~/.profile
echo "export LANG=en_US.UTF-8" >> ~/.profile

# Switch shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)

echo "" >> ~/.zshrc
echo "# tmux" >> ~/.zshrc
echo 'alias tm="tmux attach -t init || tmux new-session -s init"' >> ~/.zshrc
