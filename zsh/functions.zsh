function op         () { thunar   ${1:-.}        </dev/null &>/dev/null & disown }
function manp       () { zathura =(man -Tpdf $@) </dev/null &>/dev/null & disown }
function manv       () { man $@ | vim "+runtime! syntax/man.vim" "+set nonumber" "+set norelativenumber" }
function ta         () { if [ -z "$1" ]; then tmux attach; else tmux attach -t $1; fi }
function randstring () { cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1 }
function bwu        () { export BW_SESSION="$(bw unlock --raw)" && bw sync }
function qrimg      () { qrencode -t png -r /dev/stdin -o /dev/stdout | convert - -interpolate Nearest -filter point -resize 1000% png:/dev/stdout }
function toh264     () { ffmpeg -i "$1" -c:v libx264 -c:a copy "${1:r}_h264.mp4" }
function sc         () { jq .scripts ${1:-package.json} }

# Good compression/archive settings
function compress () { tar c -I"xz -T 0 -7" -f $1.tar.xz $1 }
function archive () { tar c -I"xz -T 0 -0" -f $1.tar.xz $1 }
alias decompress='tar xfJ'

# kube
function kns () { kubectl config set-context --current --namespace="$1" }

function plot () {
    if [ "$1" = "--help" ]; then
        echo "plot <filename> [style] [x column number] [y column number]"
        echo "useful styles: dots, lines, boxes"
        return
    fi

    style=${2:-dots}
    x=${3:-1}
    y=${4:-2}

    first_line=$(head -n 1 "$1")
    xlabel=$(cut -d, -f"$x" <<< "$first_line")
    ylabel=$(cut -d, -f"$y" <<< "$first_line")
    title=${1:t}
    output="${1:t:r}.svg"

    gnuplot_code="
    set title '$title'
    set datafile separator ','
    set xlabel '$xlabel'
    set ylabel '$ylabel'
    set grid
    set terminal svg enhanced
    set output '$output'
    plot '$1' using $x:$y with $style title columnhead
    "

    gnuplot -c =(<<< "$gnuplot_code")
}

function bb () {
    if [ "$1" = "down" ]; then
        gio trash ./tsconfig.json
        gio trash ./package.json
        rm -rf ./node_modules/ bun.lockb
    fi

    if [ "$1" = "up" ]; then
    cat << EOF > ./tsconfig.json
{
  "compilerOptions": {
    "types": ["bun-types"],
    "lib": ["esnext"],
    "module": "esnext",
    "target": "esnext",
    "moduleResolution": "bundler",
    "noEmit": true,
    "allowImportingTsExtensions": true,
    "moduleDetection": "force",
    "esModuleInterop": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  }
}
EOF

    cat << EOF > ./package.json
{ "dependencies": { "@types/node": "18", "bun-types": "latest" } }
EOF

        bun install
    fi
}

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
    alias cpr='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1'
    if [ "$1" = "clips" ]; then
        echo "syncing clips"
        cpr -e ssh --exclude 'replays/*' ~/Videos/ homelab:Videos/cloud/
        return
    elif [ "$1" = "files" ]; then
        echo "syncing personal files to external drive"
        cpr                       /mnt/homelab/seagate/music/ "/run/media/jayden/Seagate External/Backup/Personal Files/Music/"
        cpr --exclude 'replays/*' /home/jayden/Videos/        "/run/media/jayden/Seagate External/Backup/Personal Files/Videos/"
        cpr --exclude 'ardour/*'  /home/jayden/Documents/     "/run/media/jayden/Seagate External/Backup/Personal Files/Documents/"
        cpr --exclude 'a6600/*'   /home/jayden/Pictures/      "/run/media/jayden/Seagate External/Backup/Personal Files/Pictures/"
        return
    fi
}

function borg_backup () {
    [ -e "$HOME/.config/ENV" ] && . "$HOME"/.config/ENV

    if [ "$BACKUP_SEAGATE_BORG_REPO" = "" ]; then
        echo "Error: Borg repo environment variable missing"
        return
    fi

    if [ "$BACKUP_SEAGATE_GCP_BUCKET" = "" ]; then
        echo "Error: GCP bucket variable missing"
        return
    fi

    if [ ! -d "$BACKUP_SEAGATE_BORG_REPO" ]; then
        echo "Error: Borg NFS mount isn't present"
        return
    fi

    borg create --compression zstd,6 --progress --stats "$BACKUP_SEAGATE_BORG_REPO"::{now} "/run/media/jayden/Seagate External/Backup"
    gsutil -m rsync -r "$BACKUP_SEAGATE_BORG_REPO/" "$BACKUP_SEAGATE_GCP_BUCKET"
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
