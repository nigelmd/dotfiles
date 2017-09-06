#!/bin/bash

# Switch shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
exit

# If tmux isn't displaying symbols correctly
echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
echo "export LANG=en_US.UTF-8" >> ~/.zshrc

echo "" >> ~/.zshrc
echo "# tmux" >> ~/.zshrc
echo 'alias tm="tmux attach -t init || tmux new-session -s init"' >> ~/.zshrc

# Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp .vimrc ~/
cp .gvimrc ~/
mkdir -p ~/.vim/colors
mkdir ~/.vim/after
cp plugins.vim ~/.vim
cp brogrammer.vim ~/.vim/colors
cp .vim/after/ftplugin ~/.vim/after/
vim -S commands.vim

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .tmux.linux.conf ~/.tmux.conf

chsh -s $(which zsh)
