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
apt-get -y install terminator
