#!/usr/bin/env bash

default_fzf_args=( "--no-multi" "--layout=reverse" )
default_fd_args=( "--base-directory=$PASSAGE_DIR" "--color=never" )

name="$(\
    fd \
        . \
        --type file \
        --extension age \
        --format '{.}' \
        "${default_fd_args[@]}" \
    | sort \
    | fzf \
        --prompt 'select > ' \
        --ghost 'search for an item' \
        --bind="enter:accept-or-print-query" \
        "${default_fzf_args[@]}" \
)"

if [ "$name" = "" ]; then
    exit 0
fi

if [ "$name" = "NEW" ]; then
    category="$(fd . "${default_fd_args[@]}" --type=directory | fzf --prompt 'category > ' "${default_fzf_args[@]}")"
    read -r -p 'name for new item > ' name
    name="${category}${name}"
    action="$(printf 'gen\ninsert' | fzf --prompt 'action > ' "${default_fzf_args[@]}")"
else
    action="$(printf 'copy\nedit\nrm\nshow\nview\nqr' | fzf --prompt 'action > ' "${default_fzf_args[@]}")"
fi

if [ "$action" = "" ]; then
    exit 0
fi

# try to make sure no funny business happens while the
# file is open in nvim
EDITOR="firejail \
--quiet \
--noprofile \
--net=none \
--whitelist=/dev/shm \
--whitelist=$HOME/.config/nvim \
--whitelist=$HOME/.local/share/nvim \
--whitelist=$DOT/vim \
--env=NVIM_PASSAGE_MODE=true \
$EDITOR"

needs_sync="false"

case "$action" in
    "copy")
        clean_name="$(echo -n "$name" | tr -dc '[:alnum:]')"
        tmp_file="$(mktemp --tmpdir=/dev/shm "passage-XXXXX-${clean_name}.txt")"
        chmod 600 "$tmp_file"

        passage show "$name" > "$tmp_file"
        exit_code=$?

        if [ ${exit_code} -ne 0 ]; then
            read -n 1 -s -r -p "Error. Press any key to continue"
        else
            chmod 400 "$tmp_file"
            while
                copy_kind="$(printf 'password\nusername' | fzf --prompt "copy $name > " "${default_fzf_args[@]}")"
                if [ "$copy_kind" = "password" ]; then
                    sed '1q;d' "$tmp_file" | tr -d '[:space:]' | xclip -selection clipboard
                elif [ "$copy_kind" = "username" ]; then
                    sed '2q;d' "$tmp_file" | tr -d '[:space:]' | xclip -selection clipboard
                fi
                [ "$copy_kind" != "" ]
            do
                read -t 60 -n 1 -s -r -p "${copy_kind^} copied. Press any key to continue or q to exit" copy_reply

                if [ $? -gt 128 ] || [ "$copy_reply" = "q" ]; then
                    break
                fi

                echo
            done
        fi

        rm -f "$tmp_file"
        exit 0;
        ;;
    "insert") ;&
    "edit")
        passage edit "$name"
        needs_sync="true"
        ;;
    "rm")
        passage rm "$name"
        needs_sync="true"
        ;;
    "gen")
        passage generate --clip "$name"
        needs_sync="true"
        ;;
    "qr")
        passage show --qrcode "$name"
        ;;
    "view") ;&
    "show")
        clean_name="$(echo -n "$name" | tr -dc '[:alnum:]')"
        tmp_file="$(mktemp --tmpdir=/dev/shm "passage-XXXXX-${clean_name}.txt")"
        chmod 600 "$tmp_file"

        passage show "$name" > "$tmp_file"
        exit_code=$?

        if [ ${exit_code} -ne 0 ]; then
            read -n 1 -s -r -p "Error. Press any key to continue"
        else
            # make it clear that this file will not be saved back into the vault
            # after the editor closes
            chmod 400 "$tmp_file"
            ${EDITOR} "$tmp_file"
        fi

        rm -f "$tmp_file"
        exit 0
    ;;
esac

echo
read -t "${PASSWORD_STORE_CLIP_TIME:-45}" -n 1 -s -r -p "Done. Press any key to continue"

if [ "$needs_sync" = "true" ]; then
    rsync \
        --archive \
        --delete \
        --human-readable --human-readable \
        --partial \
        --info=stats1,progress2 \
        --modify-window=1 \
        -e ssh \
        "$PASSAGE_DIR/" homelab:Documents/passage

    exit_code=$?
    if [ ${exit_code} -ne 0 ]; then
        read -n 1 -s -r -p "Error. Press any key to continue"
    fi
fi
