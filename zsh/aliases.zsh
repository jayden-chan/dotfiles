# Stop activating ghostscript by accident
alias gs='git status'

# dotfile editing
alias gdf='cd $DOT && git status'

# Exit
alias :q='exit'
alias :qa='exit'
alias :Q='exit'
alias :wq='exit'
alias :Wq='exit'
alias :q!='exit'
alias :qa!='exit'
alias :Q!='exit'
alias :wq!='exit'
alias :Wq!='exit'

# Editor
alias vim='nvim'

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
alias n='npm'
alias o='xdg-open'
alias t='tmux'
alias b='bun'
alias c='cargo'
alias j='just'
alias k='kubectl'
alias l='eza --all'

# networking
alias cpr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh'
alias mvr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh'
alias myip='curl https://ipinfo.io/ip && echo'

# better defaults
alias clear='clear -x'
alias ls='eza --binary'
alias la='eza --long --header --binary --all'
alias ll='eza --long --header --binary'
alias cat='bat'
alias bc='bc --mathlib --quiet'
alias ip='ip -c'
alias sxiv='nsxiv --no-bar'
alias make='make --no-print-directory'
alias node='node --enable-source-maps --unhandled-rejections=strict'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias ffprobej='ffprobe -v quiet -hide_banner -print_format json -show_format -show_streams'
alias pass='passage'

# Other
alias clip='xclip -selection c'
alias pasteimg='xclip -selection clipboard -t image/png -o'
alias gpl='curl https://www.gnu.org/licenses/gpl-3.0.txt'
alias agpl='curl https://www.gnu.org/licenses/agpl-3.0.txt'
alias curlv='curl --verbose'
alias pg='ps -ax | rg'
alias videoman="$HOME/Dev/videoman/src/index.ts"
alias prodge="$HOME/Dev/prodge/src/index.ts"
alias pd="$HOME/Dev/prodge/src/index.ts"
alias tw='.git-ignored-general/tw.sh'
