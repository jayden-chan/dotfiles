function op         () { nautilus ${1:-.}       </dev/null &>/dev/null & disown }
function manp       () { evince =(man -Tpdf $@) </dev/null &>/dev/null & disown }
function manv       () { man $@ | vim "+runtime! syntax/man.vim" "+set nonumber" "+set norelativenumber" }
function ta         () { if [ -z "$1" ]; then tmux attach; else tmux attach -t $1; fi }
function cpr        () { rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh "$@" }
function mvr        () { rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh "$@" }
function randstring () { cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1 }
function tunnel     () { ssh -g -L $1\:localhost:$2 -N $3 }
function pach       () { cat /var/log/pacman.log | rg -i 'installed|upgraded|removed' | tail -$1 }

function manh () {
    tmp_dir=$(mktemp -d -t manh-XXXXXX)
    man -Thtml $1 > $tmp_dir/manual.html
    xdg-open $tmp_dir/manual.html
    sleep 1
    rm -rf $tmp_dir
}

function vpn () {
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    sudo openvpn --config $1 --auth-user-pass $HOME/Documents/pia/pass.txt
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
