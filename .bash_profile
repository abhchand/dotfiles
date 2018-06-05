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
# GIT
# Source auto-completion script
[[ -s $HOME/git-completion.bash ]] && source $HOME/git-completion.bash
# Grabs the current git branch. Will be used by the PS1 prompt set below
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

function changes_since {
  git diff $(git merge-base $1 HEAD)..HEAD
}

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

# Postgres
alias pg_start="pg_ctl -D /usr/local/var/postgres9.6 -l /usr/local/var/postgres/server.log start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres9.6 stop -s -m fast"

# RVM
alias rgl="rvm gemset list"
alias rgu="rvm gemset use"

# Python
alias json="python -mjson.tool"

# SSH
alias hal='ssh HAL.local'
# Enabling Wake-on-LAN: kodi.wiki/view/HOW-TO:Set_up_Wake-on-LAN_for_Ubuntu
alias wake_hal=`wolcmd C8:CB:B8:C7:CD:B0 192.168.1.216 255.255.255.0 4343`
alias wake_hal_ssh=`wake_hal; hal`

# OSX
alias showHidden="defaults write com.apple.Finder AppleShowAllFiles TRUE && killall Finder"
alias hideHidden="defaults write com.apple.Finder AppleShowAllFiles FALSE && killall Finder"

# Glassbreakers
alias gb="cd ~/git/glassbreakers/glassbreakers-prototype/"

# ###################################
# EXPORTS

export HISTTIMEFORMAT="%m/%d/%y %T "
export CLICOLOR=1
export JAVA_HOME="/usr/local/java/jdk1.8.0_45/"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export FLASK_DEBUG=1

# PS1 Prompt
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
export PS1="\W $YELLOW\$(parse_git_branch)$GREEN > "

# ###################################
# PATH

# Java
PATH=$PATH:/usr/local/java/jdk1.8.0_45/bin/
# MySQL
PATH=$PATH:/usr/local/mysql/bin
# RVM
PATH=$PATH:$HOME/.rvm/bin
# pyenv
PATH=$PYENV_ROOT/bin:$PATH
# User specific /bin folder
PATH=$PATH:$HOME/bin

export PATH


# ###################################
# MISC.

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Initialize pyenv
eval "$(pyenv init -)"

# Exercism auto-complete
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi

# Rails - only run changed specs
function run_changed_specs {
  arg=$1
  branch=${arg:-master}

  files=$(git diff $branch..HEAD --name-only | grep spec | grep -v factories | grep -v spec_helper.rb | grep -v spec/support)

  echo "==="
  echo "Running files changed since $branch:"
  echo $files
  echo ""

  rspec $(echo $files | tr '\n' ' ')
}


export RELEASE_BRANCH=r2018.04.09
alias gcr="git checkout $RELEASE_BRANCH"
alias gpr="git pull origin $RELEASE_BRANCH"
alias gcm="git checkout master"
alias gcd="git checkout development"


