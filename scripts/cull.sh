#!/bin/zsh

dir="$1"
base_path="/home/jayden/Pictures/a6600"

date

# -t     Start in thumbnail mode.
# -b     Do not show info bar on bottom of window.
# -o     Write list of all marked files to standard output when quitting.
# -g     <GEOMETRY> Set window position and size.
images=$(echo "$@" | xargs sxiv -b -o -g 1600x900)

num_files=0
num_xmps=0
num_jpegs=0
num_raws=0
while IFS= read -r i; do 
    if [ "$i" = "" ]; then
        echo "No files selected for deletion, exiting"
        break
    fi

    echo "Processing \"$i\""
    raw_file="$base_path/raw/${i:t:r}.ARW"
    if [ -f "$raw_file" ]; then
        echo "Trashing ARW file $raw_file"
        gio trash "$raw_file"
        ((num_raws++))
        ((num_files++))
    fi

    xmp_file="$base_path/raw/${i:t:r}.ARW.xmp"
    if [ -f "$xmp_file" ]; then
        echo "Trashing sidecar XMP file $xmp_file"
        gio trash "$xmp_file"
        ((num_xmps++))
        ((num_files++))
    fi

    echo "Trashing original file $i"
    gio trash "$i"
    ((num_jpegs++))
    ((num_files++))
done <<<"$images"

notify-send --expire-time=60000 "cull.sh" "Sent $num_files files to trash ($num_jpegs jpeg, $num_raws raw, $num_xmps xmp)"
