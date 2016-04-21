alias rasberryPieLan="ssh raspberrypilan"
alias raspberrPieWifi="ssh raspberrypiwifi"

alias csc555="ssh csc555"

alias gs="git status"
alias gadd="git add ."
alias ggpull="git pull origin master"
alias ggpush="git push origin master"

alias relaunchVirtualBox="sudo \"/Library/Application Support/VirtualBox/LaunchDaemons/VirtualBoxStartup.sh\" restart"
alias vm="ssh vagrant@127.0.0.1 -p 2222"

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

PHP_AUTOCONF="/usr/local/bin/autoconf"

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# # cache pip-installed packages to avoid re-downloading
#export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
