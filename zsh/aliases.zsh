# Stop activating ghostscript by accident
alias gs='git status'

# Compilation
alias lcm='latexmk -pvc -pdf'
alias god='cd $GOPATH/src/github.com/jayden-chan/'
alias hh='git push heroku master && heroku logs --tail'

# dotfile editing
alias gdf='cd $DOT && git status'
alias vimrc='vim $DOT/vim/vimrc'
alias zshrc='vim $DOT/zsh/zshrc'

# Exit
alias :q='exit'
alias :Q='exit'
alias :wq='exit'
alias :Wq='exit'

# Editor
alias vim='nvim'

# Fuzzy cd/vim
alias zz='cd `fd . ~ --type d | fzf`'
alias ed='vim `fd . ~ --type f | fzf`'

# U S E R   E R R O R
alias cim='vim'
alias vom='vim'
alias vun='vim'
alias ivm='vim'
alias bim='vim'
alias dw='cd'
alias cs='cd'
alias clear='clear -x'
alias clera='clear'
alias celar='clear'
alias clare='clear'
alias claer='clear'
alias ckear='clear'
alias Lq='exit'

# One letter
alias y='yarn'
alias o='xdg-open'
alias x='xset r rate 270 35'
alias t='tmux'
alias c='cargo'

# Good compression/archive settings
alias compress='tar c -I"xz -T 0 -7" -f'
alias archive='tar c -I"xz -T 0 -0" -f'
alias decompress='tar xfJ'

# networking
alias cpr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh'
alias mvr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh'
alias wgr='sudo wg-quick down wg0 && sudo wg-quick up wg0'
alias nfsup='sudo mount -t nfs -o vers=4 192.168.1.118:/ /mnt/homelab'
alias nfsdown='sudo umount -R /mnt/homelab'
alias ufwadd='sudo ufw allow proto udp/tcp from 192.168.1.0/24 to any port 123 comment "Comment"'
alias myip='curl https://ipinfo.io/ip && echo'

# ls
alias l='exa -a'
alias ls='exa'
alias la='exa -lah'
alias ll='exa -lh'

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
