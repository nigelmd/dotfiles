#!/bin/bash

# Switch shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
  echo "Could not install Oh My Zsh" >/dev/stderr
  exit 1
}

# Fix permissions
sudo chown -R "$USER":"$USER" ~/.oh-my-zsh ~/.zshrc ~/.zsh_history ~/.zsh-update ~/.zshrc-e

# If tmux isn't displaying symbols correctly
echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
echo "export LANG=en_US.UTF-8" >> ~/.zshrc

echo "" >> ~/.zshrc
echo "# tmux" >> ~/.zshrc
echo 'alias tm="tmux -2 attach -t init || tmux -2 new-session -s init"' >> ~/.zshrc

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
cp .tmux.conf ~/.tmux.conf
# start a server but don't attach to it
tmux start-server
# create a new session but don't attach to it either
tmux new-session -d
# install the plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh
# killing the server is not required, I guess
tmux kill-server

# Setup fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ../
rm -rf fonts
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
mv PowerlineSymbols.otf ~/.local/share/fonts
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
fc-cache -vf ~/.local/share/fonts

# change shell
chsh -s $(which zsh)
