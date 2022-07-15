# Stop activating ghostscript by accident
alias gs='git status'

# Compilation
alias lcm='latexmk -pvc -pdfxe -shell-escape'
alias god='cd $GOPATH/src/github.com/jayden-chan/'
alias hh='git push heroku master && heroku logs --tail'

# dotfile editing
alias gdf='cd $DOT && git status'
alias zshrc='vim $DOT/zsh/zshrc'

# Exit
alias :q='exit'
alias :Q='exit'
alias :wq='exit'
alias :Wq='exit'
alias :q!='builtin exit'
alias :Q!='builtin exit'
alias :wq!='builtin exit'
alias :Wq!='builtin exit'

# Editor
alias vim='nvim'
alias ng='nvim -c "Neogit kind=replace"'

# U S E R   E R R O R
alias cim='vim'
alias vom='vim'
alias vun='vim'
alias ivm='vim'
alias bim='vim'
alias dw='cd'
alias cs='cd'
alias clera='clear'
alias celar='clear'
alias clare='clear'
alias claer='clear'
alias ckear='clear'
alias Lq='exit'

# One letter
alias y='yarn'
alias o='xdg-open'
alias t='tmux'
alias c='cargo'

# networking
alias cpr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh'
alias mvr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh'
alias ufwadd='sudo ufw allow proto udp/tcp from 192.168.1.0/24 to any port 123 comment "Comment"'
alias myip='curl https://ipinfo.io/ip && echo'

# better defaults
alias clear='clear -x'
alias l='exa -a'
alias ls='exa'
alias la='exa -lah'
alias ll='exa -lh'
alias cat='bat'
alias bc='bc -l'
alias ip='ip -c'
alias sxiv='sxiv -b'
alias yalc='yalc --store-folder ~/.local/share/yalc'
alias make='make --no-print-directory'

# Other
alias lpackages='comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n '"'"'s/^Package: //p'"'"' | sort -u)'
alias clip='xclip -selection c'
alias pasteimg='xclip -selection clipboard -t image/png -o'
alias nodes='node --enable-source-maps --unhandled-rejections=strict'
alias gpl='curl https://www.gnu.org/licenses/gpl-3.0.txt'
alias agpl='curl https://www.gnu.org/licenses/agpl-3.0.txt'
alias sc='jq .scripts package.json'
alias dps='docker ps --format "table {{.ID}}\t{{.RunningFor}}\t{{.Status}}\t{{.Names}}\t{{.Image}}"'
alias drs='docker-compose up -d --force-recreate --remove-orphans'
