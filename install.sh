#!/bin/bash

# Update everything first
apt -y upgrade && apt -y update

# Install all the tools
apt -y install git \
            aptitude \
            silversearcher-ag \
            zsh \
            tmux \
            vim \
            vim-gnome \
            terminator \
            curl \
            fontconfig \
            python-pip
