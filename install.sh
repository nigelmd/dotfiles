#!/bin/bash

# Update everything first
apt -y upgrade && apt -y update

# Install all the tools
apt -y install git
apt -y install aptitude
apt -y install silversearcher-ag
apt -y install zsh
apt -y install tmux
apt -y install vim
apt -y install vim-gnome
apt -y install terminator
apt -y install curl
apt -y install fontconfig
apt -y install python-pip
