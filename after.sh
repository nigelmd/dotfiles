# If tmux isn't displaying symbols correctly
echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
echo "export LANG=en_US.UTF-8" >> ~/.zshrc

echo "" >> ~/.zshrc
echo "# tmux" >> ~/.zshrc
echo 'alias tm="tmux attach -t init || tmux new-session -s init"' >> ~/.zshrc

# restart zsh
exit
zsh
