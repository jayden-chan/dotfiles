function op         () { thunar   ${1:-.}        </dev/null &>/dev/null & disown }
function manp       () { zathura =(man -Tpdf $@) </dev/null &>/dev/null & disown }
function manv       () { man $@ | vim "+runtime! syntax/man.vim" "+set nonumber" "+set norelativenumber" }
function ta         () { if [ -z "$1" ]; then tmux attach; else tmux attach -t $1; fi }
function randstring () { cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1 }
function pach       () { cat /var/log/pacman.log | rg -i 'installed|upgraded|removed' | tail -$1 }
function bwu        () { export BW_SESSION="$(bw unlock --raw)" && bw sync }
function qrimg      () { qrencode -t png -r /dev/stdin -o /dev/stdout | convert - -interpolate Nearest -filter point -resize 1000% png:/dev/stdout }
function toh264     () { ffmpeg -i "$1" -c:v libx264 -c:a copy "${1:r}_h264.mp4" }

# Good compression/archive settings
function compress () { tar c -I"xz -T 0 -7" -f $1.tar.xz $1 }
function archive () { tar c -I"xz -T 0 -0" -f $1.tar.xz $1 }
alias decompress='tar xfJ'

# kube
function kw () { kubectl "$@" -o wide }
function kww () { kubectl "$@" -o wide -w }
function kns () { kubectl config set-context --current --namespace="$1" }

function gig () {
    if [[ "$1" == "ls" ]]; then
        curl --silent https://api.github.com/repos/github/gitignore/contents/ | jq '.[].name' -r | rg "\.gitignore" --replace=''
        return
    fi

    code=$(curl \
        --silent \
        --write-out "%{http_code}" \
        --output /tmp/gig.txt \
        https://raw.githubusercontent.com/github/gitignore/main/$1.gitignore)

    if [[ "$code" == "200" ]]; then
        cat /tmp/gig.txt >> .gitignore
    else
        echo "Error: No gitignore template for $1 exists"
    fi
    rm -f /tmp/gig.txt
}

function gotify-send () {
    if [[ "$GOTIFY_TOKEN" = "" ]]; then
        echo "no token"
    else
        curl "https://gotify.jayden.codes/message?token=$GOTIFY_TOKEN" -F "title=$1" -F "message=$2" -F "priority=5"
    fi
}

function syc () {
    alias cpr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh'
    if [ "$1" = "up" ]; then
        echo "syncing up"
        cpr ~/Documents/ homelab:Documents/cloud/
        cpr ~/Pictures/  homelab:Pictures/cloud/
        cpr ~/Videos/    homelab:Videos/cloud/
        return
    elif [ "$1" = "down" ]; then
        echo "syncing down"
        cpr homelab:Documents/cloud/ ~/Documents/
        cpr homelab:Pictures/cloud/  ~/Pictures/
        cpr homelab:Videos/cloud/    ~/Videos/
        return
    fi
}

function gitea_mirror () {
    # unlock the vault if it's not already unlocked
    if [ "$BW_SESSION" = "" ]; then
        export BW_SESSION="$(bw unlock --raw)"
        bw sync 1>&2
    fi

    gitea_token=$(bwg "Gitea Mirror Account OAuth Token")
    github_token=$(bwg "Gitea Mirror Account Pull Token")

    if [ "$1" = "" ]; then
        echo "usage: gitea_mirror https://github.com/user/repo"
        return
    fi

    setopt localoptions shwordsplit

    url="$1"

    saveIFS="$IFS"
    IFS='/'
    a=(${url})
    IFS="$saveIFS"

    name="${a[${#a[@]}]}"

    echo "mirroring: $url [$name]"

    curl --request POST \
      --url https://git.jayden.codes/api/v1/repos/migrate \
      --header "Authorization: token $gitea_token" \
      --header 'Content-Type: application/json' \
      --data "{
        \"clone_addr\": \"$url\",
        \"repo_name\": \"$name\",
        \"auth_token\": \"$github_token\",
        \"issues\": false,
        \"labels\": false,
        \"lfs\": false,
        \"milestones\": false,
        \"mirror\": true,
        \"mirror_interval\": \"36h00m00s\",
        \"private\": false,
        \"pull_requests\": false,
        \"releases\": false,
        \"service\": \"github\",
        \"wiki\": false
    }"
}

function bwg () {
    # unlock the vault if it's not already unlocked
    if [ "$BW_SESSION" = "" ]; then
        export BW_SESSION="$(bw unlock --raw)"
        bw sync 1>&2
    fi

    items=$(bw list items --search $1)
    usernames=($(jq '.[].login.username' --raw-output <<< "$items"))
    if [ "$2" = "u" ]; then
        results=($(jq '.[].login.username' --raw-output <<< "$items"))
    else
        results=($(jq '.[].login.password' --raw-output <<< "$items"))
    fi

    if [ "$results" = "null" ]; then
        results=($(jq '.[].notes' --raw-output <<< "$items"))
    fi

    if [ "${#usernames[@]}" = "1" ]; then
        echo -n "${results[1]}"
    else
        select opt in "${usernames[@]}"; do
            echo -n "${results[$REPLY]}"
            break
        done
    fi
}

function zcustomfunc () {
    local BOOKMARKS_FILE="$HOME/.cache/bookmarks"
    if [ ! -f "$BOOKMARKS_FILE" ]; then
        touch "$BOOKMARKS_FILE"
    fi

    if [[ "$1" = "bookmark" ]]; then
        if [[ "$2" != "" ]]; then
            local tmp_file=$(mktemp)
            echo "$2 $PWD" >> $BOOKMARKS_FILE
            cat "$BOOKMARKS_FILE" | sort | uniq > $tmp_file
            cat "$tmp_file" > $BOOKMARKS_FILE
            rm "$tmp_file"
        else
            cat "$BOOKMARKS_FILE"
        fi
    elif [[ "$1" != "" ]]; then
        local bookmark=$(rg "^$1 (.*?)\$" "$BOOKMARKS_FILE" --only-matching --replace '$1')
        if [[ "$bookmark" == "" ]]; then
            zshz 2>&1 "$@"
        else
            cd "$bookmark"
        fi
    else
        zshz 2>&1 "$@"
    fi
}
alias z="zcustomfunc"

function manh () {
    tmp_dir=$(mktemp -d -t manh-XXXXXX)
    man -Thtml $1 > $tmp_dir/manual.html
    xdg-open $tmp_dir/manual.html
    sleep 1
    rm -rf $tmp_dir
}

function installfont () {
    sudo echo --- Installing font ---
    cp $@ $HOME/.local/share/fonts
    echo --- Refreshing font cache ---
    sudo fc-cache -fv
    echo --- Done ---
}

function cargo_init() {
    if [ "$1" = "" ]; then
        echo "You must specify a project name"
    else
        cargo init $1
        cd $1
        touch README.md
        echo "# $1" > README.md

        if [ "$2" != "" ]; then
            echo "\n$2" >> README.md
        fi

        touch Makefile
        echo "build: build-native\n" >> Makefile
        echo "build-general:\n\tcargo build --release\n" >> Makefile
        echo "build-native:\n\tRUSTFLAGS=\"-Ctarget-cpu-native\" cargo build --release\n" >> Makefile
        echo ".PHONY: build build-general build-native" >> Makefile

        touch rustfmt.toml
        echo "max_width = 80" > rustfmt.toml
        echo "Project creation finished, don't forget to add a license"
    fi
}

function ts_init() {
    if [ "$1" = "" ]; then
        echo "You must specify a project name"
    else
        mkdir $1
        cd $1
        git status >/dev/null 2>&1 || { git init }
        yarn init
        mkdir src

        echo "# $1" > README.md
        echo "function main() {\n  console.log(\"Hello world\");\n}\n\nmain();" > src/index.ts
        echo "dist\nnode_modules\n*.swp\n*.env" > .gitignore
        echo '{
  "include": ["src/**/*.ts", "src/**/*.js", "src/**/*.json"],
  "compilerOptions": {
    "incremental": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "outDir": "dist",
    "module": "commonjs",
    "lib": ["es2020"],
    "target": "ES6",
    "inlineSourceMap": true,
    "strict": true
  }
}' > tsconfig.json

        yarn add -D @types/node@16

        if [ "$2" != "" ]; then
            echo "\n$2" >> README.md
        fi

        echo "Project created, don't forget to update package.json"
    fi

}

function mullvad_ns () {
    NS="mullvad"
    WGIF="wg0"

    command="$1"
    shift

    if [ "$command" = "up" ]; then
        conf="$1"
        if [ "$1" = "" ]; then
            echo "Provide a path to the WireGuard config file"
            return
        fi

        # extract the interface IP from the config file
        addr=$(< "$conf" rg 'Address\s+=\s+(\d+\.\d+\.\d+\.\d+/\d+)' --only-matching --replace='$1')
        # extract the DNS IP from the config file
        dns=$(< "$conf" rg 'DNS\s+=\s+(\d+\.\d+\.\d+\.\d+)' --only-matching --replace='$1')

        set -x
        sudo ip netns add $NS
        sudo ip link add $WGIF type wireguard
        sudo ip link set $WGIF netns $NS
        sudo ip netns exec $NS wg setconf $WGIF $conf
        sudo ip -n $NS addr add $addr dev $WGIF
        sudo ip -n $NS link set lo up
        sudo ip -n $NS link set $WGIF up
        sudo ip -n $NS route add default dev $WGIF
        sudo mkdir -p /etc/netns/$NS
        echo "nameserver $dns" | sudo tee /etc/netns/$NS/resolv.conf
        set +x
    fi

    if [ "$command" = "down" ]; then
        sudo ip netns delete $NS
        sudo rm -rf /etc/netns/$NS
    fi

    if [ "$command" = "exec" ]; then
        firejail --noprofile --netns=$NS "$@"
    fi
}

# try not to exit the terminal with un-pushed git commits
function exit () {
    gitlog=$(git log @{upstream}.. 2>/dev/null)
    if [[ $? -ne 0 ]]; then builtin exit; fi
    if [[ $(printf '%s' "$gitlog" | wc -c) -ne 0 ]]; then
        echo "Oops! You forgot to push your commits to the upstream repo."
        echo -n "Would you like to push them before exiting? [Y/n] "
        read answer

        if [ "$answer" != "${answer#[Yy]}" ]; then
            git push || return -1
        fi
    fi
    builtin exit
}
