# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dgb"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(systemd taskwarrior git)

export LANG=en_US.UTF-8

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATH=$PATH:~/.local/bin:~/.dotfiles/local/bin
export LANG=en_US.UTF-8
export PATH
#JAVA_HOME=/opt/java
export JAVA_HOME
export EDITOR="vim"

# aliases
alias root="sudo -Es"
alias lah="ls -lah"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen %cD (%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glbr="git for-each-ref --sort=-committerdate refs/remotes/origin/ | head"
alias please='\sudo $(fc -ln -1)'
alias nload="nload -u H"
alias quickvim="vim -u ~/.quickvimrc"
alias sc="sudo systemctl"
alias mvnf="mvn -T 2C"
alias mvnff="mvn -DskipTests -Dmaven.javadoc.skip=true -T 2C"
alias tf="terraform"
alias egrep="egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias awsc="alks sessions console -N"
alias gbr="git branch --sort=-committerdate | head -n 10"

export SPARK SPARK_LOCAL_IP="127.0.0.1"
export MAVEN_OPTS="-Xms512m -Xmx1024m -XX:PermSize=768m -XX:MaxPermSize=4096m"

function grephistory {
    git rev-list --all | xargs git grep $1
}

source ~/.zshrc_local

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
