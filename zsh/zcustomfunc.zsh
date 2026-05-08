function zcustomfunc () {
    local BOOKMARKS_FILE="$HOME/.local/share/zshz/bookmarks"

    if [ "$1" = "--help" ] || [ "$1" = "" ]; then
        echo 1>&2 "Error: must provide an argument to \`z\`"
        echo 1>&2
        echo 1>&2 "Usage: z <bookmark name>          -- go to bookmark"
        echo 1>&2 "       z bookmark <bookmark name> -- add CWD as bookmark with name"
    elif [ "$1" = "bookmark" ]; then
        if [ "$2" != "" ]; then
            local tmp_file=$(mktemp)
            echo "$2	$PWD" >> "$BOOKMARKS_FILE"
            cat "$BOOKMARKS_FILE" | sort | uniq > "$tmp_file"
            cat "$tmp_file" > "$BOOKMARKS_FILE"
            rm "$tmp_file"
        else
            cat "$BOOKMARKS_FILE"
        fi
    else
        local bookmark=$(rg "^$1	(.*?)\$" "$BOOKMARKS_FILE" --only-matching --replace '$1')
        if [ "$bookmark" = "" ]; then
            dev_folder="$HOME/Dev/$1"
            if [ -d "$dev_folder" ]; then
                cd "$dev_folder"
            else
                echo 1>&2 "Error: \"$1\" is not in the bookmarks file"
            fi
        else
            cd "$bookmark"
        fi
    fi
}

alias z="zcustomfunc"
