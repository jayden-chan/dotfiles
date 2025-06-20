function _post_to_shist () {
    if [ "$SHIST_URL" = "" ] || [ "$SHIST_TOKEN" = "" ]; then
        return
    fi

    local res=$(curl "$SHIST_URL/history" \
        --max-time 2 \
        --silent \
        --header "authorization: $SHIST_TOKEN" \
        --json "$(jq -sRrc '{commands: [.]}' <<< "$1")")

    local res_status="$(echo "$res" | jq -r .status)"
    if [ "$res_status" != "ok" ]; then
        echo "shist error: $res"
    fi
}

function _shist_widget() {
    if [ "$SHIST_URL" = "" ] || [ "$SHIST_TOKEN" = "" ]; then
        return 1
    fi

    local selected
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null
    selected="$(curl --compressed --silent -H "authorization: $SHIST_TOKEN" "$SHIST_URL/history?nul_sep=true" | fzf --query="$LBUFFER" --read0)"
    local ret=$?

    if [ -n "$selected" ]; then
        if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
            zle vi-fetch-history -n $MATCH
        else # selected is a custom query, not from history
            LBUFFER="$selected"
        fi
    fi

    zle reset-prompt
    return $ret
}

function shearch () {
    curl \
        --compressed \
        --silent \
        -H "authorization: $SHIST_TOKEN" \
        "$SHIST_URL/history?nul_sep=true" \
    | fzf --read0 \
    | xclip -selection c
}

add-zsh-hook zshaddhistory _post_to_shist
zle     -N            _shist_widget
bindkey -M emacs '^R' _shist_widget
bindkey -M vicmd '^R' _shist_widget
bindkey -M viins '^R' _shist_widget
