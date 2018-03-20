# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/jayden/.oh-my-zsh

ZSH_THEME="agnoster"
DEFAULT_USER="jayden"
prompt_context(){}
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

stty stop undef
stty start undef

# Git alias
alias gdf='cd ~/Documents/Git/dotfiles'
alias gpf='cd ~/Documents/Git/programming-folder'
alias gc='git commit -v -S'

# Compilation
alias javc='javac -Xlint:all'
alias lcm='latexmk -pvc -pdf'
alias gr='./gradlew'

# dotfile editing
alias vimrc='vim /home/jayden/Documents/Git/dotfiles/vim/.vimrc'
alias zshrc='vim /home/jayden/Documents/Git/dotfiles/zsh/.zshrc'
alias dotup='sh /home/jayden/Documents/Git/dotfiles/scripts/dots-up.sh'
alias dotdown='sh /home/jayden/Documents/Git/dotfiles/scripts/dots-down.sh'

# Exit
alias :q='exit'
alias :Q='exit'

# Other
alias sshd='ssh jayden@jaydendesktop.ddns.net'
alias lpackages='comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n '"'"'s/^Package: //p'"'"' | sort -u)'

[[ $TMUX = "" ]] && export TERM="xterm-256color"

# Export gradle path
export PATH=$PATH:/opt/gradle/gradle-4.6/bin

# Functions
function updatesys () {
    sudo echo --- Performing full system update ---
    echo
    sudo apt update
    echo
    echo --- List upgrade packages ---
    echo
    apt list --upgradable
    echo
    sudo apt upgrade
    sudo apt autoremove
    echo
    echo --- Finished full system upgrade ---
}
