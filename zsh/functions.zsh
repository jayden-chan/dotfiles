function op         () { nautilus ${1:-.}       </dev/null &>/dev/null & disown }
function manp       () { zathura =(man -Tpdf $@) </dev/null &>/dev/null & disown }
function manv       () { man $@ | vim "+runtime! syntax/man.vim" "+set nonumber" "+set norelativenumber" }
function ta         () { if [ -z "$1" ]; then tmux attach; else tmux attach -t $1; fi }
function cpr        () { rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh "$@" }
function mvr        () { rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh "$@" }
function randstring () { cat /dev/urandom | tr -dc 'a-zA-Z0-9<>/?"~!#$%^&*()=-' | fold -w $1 | head -n 1 }
function pach       () { cat /var/log/pacman.log | rg -i 'installed|upgraded|removed' | tail -$1 }
function bwu        () { export BW_SESSION="$(bw unlock --raw)" && bw sync }

function gotify-send () {
    if [[ "$GOTIFY_TOKEN" = "" ]]; then
        echo "no token"
    else
        curl "https://gotify.jayden.codes/message?token=$GOTIFY_TOKEN" -F "title=$1" -F "message=$2" -F "priority=5"
    fi
}

function bwg () {
    # unlock the vault if it's not already unlocked
    if [ "$BW_SESSION" = "" ]; then
        export BW_SESSION="$(bw unlock --raw)"
        bw sync
    fi

    items=$(bw list items --search $1)
    usernames=($(jq '.[].login.username' --raw-output <<< "$items"))

    if [ "$2" = "u" ]; then
        results=($(jq '.[].login.username' --raw-output <<< "$items"))
    else
        results=($(jq '.[].login.password' --raw-output <<< "$items"))
    fi

    if [ "${#usernames[@]}" = "1" ]; then
        echo -n "${results[1]}" | xclip -selection clipboard
    else
        select opt in "${usernames[@]}"; do
            echo -n "${results[$REPLY]}" | xclip -selection clipboard
            break
        done
    fi
}

function setwall () {
    chosen_wall=$(sudo fd . -e png -e jpg -e jpeg -e webp | sxiv - -t -o)
    if [ "$chosen_wall" = "" ]; then
        echo "no image chosen"
    else
        nitrogen --set-zoom-fill --save "$chosen_wall" --head=0
        nitrogen --set-zoom-fill --save "$chosen_wall" --head=1
        nitrogen --set-zoom-fill --save "$chosen_wall" --head=2
        sudo cp "$chosen_wall" /usr/share/backgrounds/wall
    fi
}

function zcustomfunc () {
    local BOOKMARKS_FILE="$HOME/.cache/bookmarks"
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
    cp $1 $HOME/.local/share/fonts
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
        echo "build: build-skylake\n" >> Makefile
        echo "build-general:\n\tcargo build --release\n" >> Makefile
        echo "build-native:\n\tRUSTFLAGS=\"-Ctarget-cpu-native\" cargo build --release\n" >> Makefile
        echo ".PHONY: build build-general build-skylake" >> Makefile

        touch rustfmt.toml
        echo "max_width = 80" > rustfmt.toml

        touch LICENSE

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

        yarn add -D typescript @types/node

        if [ "$2" != "" ]; then
            echo "\n$2" >> README.md
        fi

        echo "Project created, don't forget to update package.json"
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
