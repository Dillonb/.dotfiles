# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

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
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias please='\sudo $(fc -ln -1)'
alias nload="nload -u H"
alias quickvim="vim -u ~/.quickvimrc"

function grephistory {
    git grep $1 $(git rev-list --all)
}

source ~/.zshrc_local

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
PATH="/home/dillon/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/dillon/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/dillon/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/dillon/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/dillon/perl5"; export PERL_MM_OPT;
