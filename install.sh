#!/bin/bash

# Update everything first
sudo apt-get -y upgrade && sudo apt-get -y update

# Install all the tools
sudo apt-get -y install git
sudo apt-get -y install aptitude
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install zsh
sudo apt-get -y install tmux
sudo apt-get -y install vim
sudo apt-get -y install vim-gnome

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

# Switch shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
