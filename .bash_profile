#
# Set platform for OS-specific functionality
#
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
fi


# ###################################
# GENERAL HELPERS
# ###################################

# RSpec - run all changes since `branch`
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

# Stylelint all changes since `ref`
function stylelint_all_since {
  for FILE in $(git diff $(git merge-base $1 HEAD)..HEAD --name-only | grep scss)
  do
    echo "Linting $FILE ..."
    node_modules/.bin/stylelint --fix $FILE
  done
}

# Create thumbnails
function thumbify {
  YELLOW='\033[0;33m'
  NOCOLOR='\033[0m'

  DEFAULT_SIZE=250
  FILEPATH=$1
  ARG=$2
  SIZE=${ARG:-250}

  USAGE="
    ${YELLOW}
    Create thumbnail images \n
    Usage:\n
    \tthumbify file [dimension]\n
    \n
        \tfile\t\tfile to create thumbnail from\n
        \tdimension\tmaximum dimension (in pixels) of height or width. Aspect\n
                    \t\t\tratio will be preserved. (Default: $DEFAULT_SIZE px)\n
    \n
    Examples:\n
    \n
      \tthumbify file.jpg\n
      \tthumbify ./path/to/file.jpg\n
      \tthumbify file.jpg 350\n
    ${NOCOLOR}"


  if [ -z "$1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo -e $USAGE
    return
  fi

  if ! [ -x "$(command -v convert)" ]; then
    echo 'Error: Command `convert` not found. Are you sure ImageMagick is installed?' >&2
    return
  fi

  # Create thumnail filename
  #  ./path/to/file.jpg -> ./path/to/file-thumb.jpg
  filename=$(basename -- "$FILEPATH")
  extension="${filename##*.}"
  thumbname=`echo $FILEPATH | sed "s/.$extension/-thumb.$extension/"`

  # Create thumbnail
  echo "Creating $thumbname with max dimension $SIZE px"
  convert $FILEPATH -auto-orient -thumbnail $SIZEx$SIZE -unsharp 0x.5 $thumbname
}

#
# GIT
#

# Source auto-completion script
[[ -s $HOME/git-completion.bash ]] && source $HOME/git-completion.bash

# Grabs the current git branch. Used by the PS1 prompt set below
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

# View all changes since `ref`
function changes_since {
  git diff $(git merge-base $1 HEAD)..HEAD
}


# ###################################
# EXPORTS
# ###################################

export HISTTIMEFORMAT="%m/%d/%y %T "
export CLICOLOR=1

# PS1 Prompt
YELLOW="\[\033[0;33m\]"
GREEN_BOLD="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
RESET_COLOR="\[\033[00m\]"

export PS1="$GREEN_BOLD\u@\h$RESET_COLOR:$BLUE\w$RESET_COLOR $YELLOW$(parse_git_branch)$GREEN $ $RESET_COLOR"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Python
export PYENV_ROOT="$HOME/.pyenv"
export FLASK_DEBUG=1

# Git
export GIT_PROJECTS_DIR="$HOME/git/abhishek"

# ###################################
# PATH
# ###################################

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
# ALIASES
# ###################################

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

if [[ "$platform" == 'mac' ]]; then
  # combine_pdfs output.pdf input1.pdf input2.pdf ...
  alias combine_pdfs="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py -o"
fi

alias bp="vi $HOME/.bash_profile"
alias brc="vi $HOME/.bashrc"

alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

# Git
alias gc="git commit -a -m"
alias gcm="git checkout master"
alias gd="cd $GIT_PROJECTS_DIR"
alias gp='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gs="git status"
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


# ###################################
# MISC.
# ###################################

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Initialize pyenv
eval "$(pyenv init -)"
