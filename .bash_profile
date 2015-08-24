# ###################################
# GENERAL

# Set platform for OS-specific functionality
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
fi

# ###################################
# ALIASES

#
# Linux `ls` supports the --color flag because it's superior
# If we are on a Mac/Darwin environment, achieve the same thing by exporting the color variables
#

if [[ "$platform" == 'linux' ]]; then
  alias ls="ls -hlt --color"
  alias lsa="ls -hlta --color"
  alias tip="ls -hlt --color | head"
elif [[ "$platform" == 'mac' ]]; then
  alias ls="ls -hlt"
  alias lsa="ls -hlta"
  alias tip="ls -hlt | head"

  export CLICOLOR=1
  export LSCOLORS=ExFxCxDxBxegedabagacad
fi

alias bp="vi $HOME/.bash_profile"
alias brc="vi $HOME/.bashrc"

alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

# Git
alias gc="git commit -a -m"
alias gs="git status"
alias gp="git push origin master"
alias lol="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias lola="git log --graph --decorate --pretty=oneline --abbrev-commit --all"

# RVM
alias rgl="rvm gemset list"
alias rgu="rvm gemset use"

# Python
alias json="python -mjson.tool"

# SSH
alias hal='ssh HAL.local'

# OSX
alias showHidden="defaults write com.apple.Finder AppleShowAllFiles TRUE && killall Finder"
alias hideHidden="defaults write com.apple.Finder AppleShowAllFiles FALSE && killall Finder"

# ###################################
# EXPORTS

export HISTTIMEFORMAT="%m/%d/%y %T "
export PS1="[\u@\h] \W > "
export CLICOLOR=1
export JAVA_HOME="/usr/local/java/jdk1.8.0_45/"

# ###################################
# PATH

# Java
PATH=$PATH:/usr/local/java/jdk1.8.0_45/bin/
# MySQL
PATH=$PATH:/usr/local/mysql/bin
# RVM
PATH=$PATH:$HOME/.rvm/bin
# User specific /bin folder
PATH=$PATH:$HOME/bin

export PATH


# ###################################
# MISC.

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
