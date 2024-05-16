#!/bin/zsh

set -e

sd_path="$1"
dest_path="$HOME/Pictures/a6600"
photos_path="$sd_path/DCIM/100MSDCF/"
videos_path="$sd_path/PRIVATE/M4ROOT/CLIP/"

if [ "$sd_path" = "" ]; then
    echo "Error: You must provide the path to import from"
    exit 1
fi

if [ ! -d "$dest_path" ]; then
    echo "Error: Destination import path does not exist"
    exit 1
fi

if [ -d "$sd_path" ]; then
    echo "Found SD card on file system."
else
    echo "Error: SD card isn't mounted to file system."
    exit 1
fi

photos=""
num_photos="0"
real_num_photos="0"
if [ -d "$photos_path" ]; then
    photos=$(fd . "$photos_path" --extension ARW --extension JPG)
    num_photos=$(echo "$photos" | wc -l)
    real_num_photos=$(($((num_photos)) / 2))
fi

videos=""
num_videos="0"
if [ -d "$videos_path" ]; then
    videos=$(fd . "$videos_path" --extension MP4)
    if [ "$videos" != "" ]; then
        num_videos=$(echo "$videos" | wc -l)
    fi
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
            resulting_file="$dest_path/raw/${date}_${file:t}"
            echo -n "(RAW) "
        elif [ "$ext" = "JPG" ]; then
            resulting_file="$dest_path/sdr/${date}_${file:t}"
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
        resulting_file="$dest_path/video/${date}_${file:t}"

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

notify-send --expire-time=60000 "sd-dump.sh" "$result_message"
