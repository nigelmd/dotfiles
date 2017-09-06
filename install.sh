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

# Switch shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
