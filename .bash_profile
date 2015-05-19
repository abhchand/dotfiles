# ###################################
# ALIAS
alias ls="ls -hlt --color"
alias lsa="ls -hlta --color"
alias rt="cd ~/Documents/"
alias hh="cd ~"

alias bp="vi ~/.bash_profile"
alias brc="vi ~/.bashrc"

alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

alias gc="git commit -a -m"
alias gs="git status"
alias gp="git push origin master"

# ###################################
# EXPORTS
export HISTTIMEFORMAT="%m/%d/%y %T "
export PS1="[\u@\h] \W > "
# Java
# TODO: Use jenv to manage mulitple java environments
PATH=$PATH:/usr/local/java/jdk1.8.0_45/bin/
JAVA_HOME="/usr/local/java/jdk1.8.0_45/"
export PATH


