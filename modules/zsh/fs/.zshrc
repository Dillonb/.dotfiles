# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

if ! command -v oh-my-posh &>/dev/null; then
    # Set name of the theme to load.
    # Look in ~/.oh-my-zsh/themes/
    # Optionally, if you set this to "random", it'll load a random theme each
    # time that oh-my-zsh is loaded.
    ZSH_THEME="ys"
fi

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
plugins=(systemd git git-escape-magic sublime-merge mosh nmap pip pipenv)
if command -v fzf &>/dev/null; then
    plugins+=(fzf)
fi

export LANG=en_US.UTF-8

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATH=$PATH:~/.local/bin:~/.dotfiles/local/bin
export LANG=en_US.UTF-8
export PATH

if command -v nvim &>/dev/null; then
    export EDITOR="nvim"
    alias vim="nvim"
else
    export EDITOR="vim"
fi

# aliases
alias root="sudo -Es"
alias lah="ls -lah"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen %cD (%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glbr="git for-each-ref --sort=-committerdate refs/remotes/origin/ | head"
alias please='\sudo $(fc -ln -1)'
alias nload="nload -u H"
alias quickvim="vim -u ~/.quickvimrc"
alias sc="sudo systemctl"
alias scu="systemctl --user"
alias jc="sudo journalctl"
alias jcu="systemctl --user"
alias mvnf="mvn -T 2C"
alias mvnff="mvn -DskipTests -Dmaven.javadoc.skip=true -T 2C"
alias mvndeps="mvn dependency:go-offline"
alias tf="terraform"
alias egrep="egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias gbr="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias nvim-config="nvim ~/.config/nvim/init.lua"
alias neovide-config="neovide ~/.config/nvim/init.lua"
if command -v xdg-open &>/dev/null; then
    alias start="xdg-open"
    alias open="xdg-open"
fi

if command -v nh &>/dev/null; then
    export FLAKE=$(readlink -f ~/.dotfiles/modules/nixos)
    eval "$(nh completions --shell zsh)"
fi

alias arch-fastestmirrors="curl -s \"https://archlinux.org/mirrorlist/?country=US&country=CA&protocol=https&use_mirror_status=on\" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -"

function grephistory {
    git rev-list --all | xargs git grep $1
}

source ~/.zshrc_local

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history

export NIXPKGS_ALLOW_UNFREE=1

# Color scheme
source ~/.dotfiles/local/data/base16-shell/base16-shell.plugin.zsh
base16_gruvbox-dark-medium

if type "direnv" > /dev/null; then
    eval "$(direnv hook zsh)"
fi

if command -v fortune &>/dev/null; then
    fortune
fi

if command -v thefuck &>/dev/null; then
    eval $(thefuck --alias)
fi

if command -v oh-my-posh &>/dev/null; then
    # if oh-my-posh is available, use that for theming
    eval "$(oh-my-posh init zsh --config ~/.dotfiles/modules/zsh/ys.omp.json)"
fi
