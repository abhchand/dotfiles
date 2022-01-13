#
# Set platform for OS-specific functionality
#

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'

  REL_PATH=`readlink -f $HOME/.bash_profile`
  SRC_DIR=`dirname $REL_PATH`
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'

  # OSX doesn't support `-f` flag
  # Working around it is non-trivial
  # See: https://stackoverflow.com/q/1055671/2490003
  REL_PATH=`readlink $HOME/.bash_profile`
  SRC_DIR=`dirname $HOME/$REL_PATH`
fi

#
# Source individual files
#

source "$SRC_DIR/profile/display"
source "$SRC_DIR/profile/docker"
source "$SRC_DIR/profile/git"
source "$SRC_DIR/profile/go"
source "$SRC_DIR/profile/helpers"
source "$SRC_DIR/profile/java"
source "$SRC_DIR/profile/kubernetes"
source "$SRC_DIR/profile/node"
source "$SRC_DIR/profile/postgres"
source "$SRC_DIR/profile/python"
source "$SRC_DIR/profile/redis"
source "$SRC_DIR/profile/rsync"
source "$SRC_DIR/profile/ruby"
source "$SRC_DIR/profile/systemd"
source "$SRC_DIR/profile/vim"
source "$SRC_DIR/profile/work"

#
# General Aliases
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

  alias showHidden="defaults write com.apple.Finder AppleShowAllFiles TRUE && killall Finder"
  alias hideHidden="defaults write com.apple.Finder AppleShowAllFiles FALSE && killall Finder"
fi

alias bp="vi $HOME/.bash_profile"
alias brc="vi $HOME/.bashrc"
alias sbp="source $HOME/.bash_profile"

# User specific /bin folder
PATH=$PATH:$HOME/bin

export PATH
