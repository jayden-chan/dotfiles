#!/bin/zsh

set -e

import_path="$1"

if [ "$import_path" = "" ]; then
    echo "Error: You must provide the path to import from"
    exit 1
fi

if [ -d "$import_path" ]; then
    echo "Found SD card on file system."
else
    echo "Error: SD card isn't mounted to file system."
    exit 1
fi

photos=$(fd . "$import_path/DCIM/100MSDCF" --extension ARW --extension JPG)
num_photos=$(echo "$photos" | wc -l)

if [ "$photos" = "" ]; then
    num_photos="0"
fi

real_num_photos=$(($((num_photos)) / 2))

videos=$(fd . "$import_path/PRIVATE/M4ROOT/CLIP/" --extension MP4)
num_videos=$(echo "$videos" | wc -l)

if [ "$videos" = "" ]; then
    num_videos="0"
fi

echo "================================================================"
echo "Number of photos to import: $real_num_photos"
echo "Number of videos to import: $num_videos"
echo "================================================================"


if [ "$photos" != "" ]; then
    echo "================================================================"
    echo "COPYING PHOTOS"
    echo "================================================================"

    current_photo=1
    for file in $(echo "$photos"); do
        ext="${file:e}"

        original_date=$(exiv2 -g 'Exif.Photo.DateTimeOriginal' -P v "$file")
        date_offset=$(exiv2 -g 'Exif.Photo.OffsetTimeOriginal' -P v "$file")
        date=$(echo "$original_date $date_offset" | sed -E -e 's/:/-/1' -e 's/:/-/1' | xargs -d '\n' date "+%Y-%m-%d_%H-%M-%S" -u -d)

        echo -n "[$current_photo/$num_photos] ${file:t} ($date) "

        resulting_file=""
        if [ "$ext" = "ARW" ]; then
            resulting_file="$HOME/Pictures/a6600/raw/${date}_${file:t}"
            echo -n "(RAW) "
        elif [ "$ext" = "JPG" ]; then
            resulting_file="$HOME/Pictures/a6600/jpeg/${date}_${file:t}"
            echo -n "(JPEG) "
        else
            echo "WARNING: Unknown file extension \"$ext\""
            exit 1
        fi

        if [ -f "$resulting_file" ]; then
            echo "-> $resulting_file (already exists, skipping)"
        else
            echo "-> $resulting_file" | sed -E "s|$HOME|~|g"
            cp "$file" "$resulting_file"
        fi

        ((current_photo++))
    done
fi

if [ "$videos" != "" ]; then
    echo "================================================================"
    echo "COPYING VIDEOS"
    echo "================================================================"

    current_video=1
    for file in $(echo "$videos"); do
        original_date=$(mediainfo "$file" | rg "Tagged date" | sort -u | rg "\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d(.*?)$" --only-matching --replace='$0' --color=never)
        date=$(echo "$original_date" | xargs -d '\n' date "+%Y-%m-%d_%H-%M-%S" -u -d)
        resulting_file="$HOME/Pictures/a6600/video/${date}_${file:t}"

        echo "[$current_video/$num_videos] ${file:t} ($date) -> $resulting_file" | sed -E "s|$HOME|~|g"
        rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$file" "$resulting_file"

        ((current_video++))
    done
fi

result_message="Imported $real_num_photos photos and $num_videos videos"

echo
echo "================================================================"
echo "$result_message"
echo "================================================================"

notify-send --expire-time=60000 "sd_dump.sh" "$result_message"
