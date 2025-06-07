function op         () { thunar ${1:-.} </dev/null &>/dev/null & disown }
function ta         () { if [ -z "$1" ]; then tmux attach; else tmux attach -t $1; fi }
function randstring () { cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1 }
function qrimg      () { qrencode -t png -r /dev/stdin -o /dev/stdout | convert - -interpolate Nearest -filter point -resize 1000% png:/dev/stdout }
function sc         () { jq .scripts ${1:-package.json} }
function kns        () { kubectl config set-context --current --namespace="$1" }
function rgd        () { rg --json -C 10 "$@" | delta }

# Good compression/archive settings
function compress () { tar c -I"xz -T 0 -7" -f $1.tar.xz $1 }
function archive () { tar c -I"xz -T 0 -0" -f $1.tar.xz $1 }
alias decompress='tar xfJ'

function _nix_git_trick () {
    # get a sudo authorization so it doesn't prompt us later in the nix process
    sudo echo ""
    # we'll use a random id to avoid accidentally messing up the .git directory
    rand_id=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

    pushd "$DOT/nix" >/dev/null || return

    # temporarily "delete" the git repo so that Nix doesn't complain
    mv ../.git "../.git-tmp-$rand_id"
    eval "$@"
    mv "../.git-tmp-$rand_id" ../.git

    popd >/dev/null
}

alias nix-rebuild='_nix_git_trick nh os switch';
alias nix-update='_nix_git_trick nix flake update';
alias nix-clean='_nix_git_trick nh clean all --keep 10';

function dkill () {
    ps -ax | rg '^\s*(\d+)(.*?)\d eslint_d' --only-matching --replace='$1' --color=never | xargs kill
    ps -ax | rg '^\s*(\d+)(.*?)\d prettierd' --only-matching --replace='$1' --color=never | xargs kill
}

function podbuild () {
    podman image build -f ./Containerfile -t git.jayden.codes/jayden/"$1":latest

    if [ "$?" = "0" ] && [ "$2" != "--no-push" ]; then
        podman image push git.jayden.codes/jayden/"$1":latest
    fi
}

function bb () {
    if [ "$1" = "down" ]; then
        trash ./tsconfig.json
        trash ./package.json
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
{ "devDependencies": { "@types/node": "22", "bun-types": "latest" }, "prettier": {} }
EOF

        bun install
    fi
}

function findreplace () {
    if [ "$1" = "--help" ]; then
        echo "findreplace <trigger> <sed expression>"
    fi

    IFS=$'\n' files=($(rg --files-with-matches "$1"))

    for f in "${files[@]}"; do
        echo "$f"
        sed -Ei "$2" "$f"
    done
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
    if [ "$GOTIFY_HOST" = "" ] || [ "$GOTIFY_TOKEN" = "" ]; then
        echo "missing host or token"
    else
        curl "https://$GOTIFY_HOST/message?token=$GOTIFY_TOKEN" -F "title=$1" -F "message=$2" -F "priority=5"
    fi
}

function syc () {
    if [ "$1" = "clips" ]; then
        echo "syncing clips"
        cpr -e ssh ~/Videos/clips/ homelab:Videos/cloud/clips/
        return
    elif [ "$1" = "csgo" ]; then
        cp "$DOT"/csgo/*.cfg ~/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo/cfg/
        rm ~/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo/cfg/lsp.cfg
    elif [ "$1" = "firefox" ]; then
        IFS=$'\n' paths=($(rg '^Path=(.*?)$' ~/.mozilla/firefox/profiles.ini --only-matching --no-line-number --color=never --replace='$1'))
        for profile in "${paths[@]}"; do
            cp "$DOT/misc/user.js"        ~/.mozilla/firefox/"$profile"/user.js
            cp "$DOT/misc/userChrome.css" ~/.mozilla/firefox/"$profile"/chrome/userChrome.css
        done
    elif [ "$1" = "files" ]; then
        echo "syncing personal files to external drive"
        echo "=== syncing Git repos"
        cpr -e ssh                homelab:docker/gitea/data/git/repositories/jayden/ "/run/media/jayden/Seagate External/Backup/Personal Files/Git/"

        echo "=== syncing music"
        cpr                       /mnt/homelab/seagate/music/ "/run/media/jayden/Seagate External/Backup/Personal Files/Music/"
        echo "=== syncing videos"
        cpr --exclude 'replays/*' "$HOME/Videos/"             "/run/media/jayden/Seagate External/Backup/Personal Files/Videos/"
        echo "=== syncing pictures"
        cpr --exclude 'a6600/*'   "$HOME/Pictures/"           "/run/media/jayden/Seagate External/Backup/Personal Files/Pictures/"
        return
    fi
}

function picopass () {
    if [ "$1" = "list" ] || [ "$1" = "ls" ]; then
        ls "$HOME/.local/share/picopass" | rg '(.*?)\.pcv$' --only-matching --replace='$1' --color=never
        return
    fi

    local plaintext_path="$HOME/.local/share/picopass/$2"
    local ciphertext_path="$HOME/.local/share/picopass/$2.pcv"

    if [ "$1" = "set" ]; then
        echo "$3" > "$plaintext_path"
        picocrypt "$plaintext_path"
        shred -u "$plaintext_path"
    fi

    if [ "$1" = "get" ]; then
        if [ ! -f "$ciphertext_path" ]; then
            >&2 echo "secret does not exist"
        else
            >&2 picocrypt "$ciphertext_path"
            \cat "$plaintext_path"
            >&2 shred -u "$plaintext_path"
        fi
    fi
}

function mullvad_ns () {
    NS="mullvad"
    WGIF="wg1"

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
