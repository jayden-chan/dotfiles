#!/bin/zsh

set -e

sd="/run/media/jayden/disk"

if [ -d "$sd" ]; then
    echo "Found SD card on file system."
else
    echo "Error: SD card isn't mounted to file system."
    exit 1
fi

photos=$(fd . "$sd/DCIM/100MSDCF" --extension ARW --extension JPG)
num_photos=$(echo "$photos" | wc -l)

videos=$(fd . "/run/media/jayden/disk/PRIVATE/M4ROOT/CLIP/" --extension MP4)
num_videos=$(echo "$videos" | wc -l)

echo "================================================================"
echo "Number of photos to import: $num_photos"
echo "Number of videos to import: $num_videos"
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
        resulting_file="/home/jayden/Pictures/a6600/raw/${date}_${file:t}"
        echo -n "(RAW) "
    elif [ "$ext" = "JPG" ]; then
        resulting_file="/home/jayden/Pictures/a6600/jpeg/${date}_${file:t}"
        echo -n "(JPEG) "
    else
        echo "WARNING: Unknown file extension \"$ext\""
        exit 1
    fi

    if [ -f "$resulting_file" ]; then
        echo "ERROR: $resulting_file already exists"
        exit 1
    fi

    echo "-> $resulting_file" | sed -E 's|/home/jayden|~|g'
    cp "$file" "$resulting_file"

    ((current_photo++))
done

echo "================================================================"
echo "COPYING VIDEOS"
echo "================================================================"

current_video=1

for file in $(echo "$videos"); do
    original_date=$(mediainfo "$file" | rg "Tagged date" | sort -u | rg "\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d(.*?)$" --only-matching --replace='$0' --color=never)
    date=$(echo "$original_date" | xargs -d '\n' date "+%Y-%m-%d_%H-%M-%S" -u -d)
    resulting_file="/home/jayden/Pictures/a6600/video/${date}_${file:t}"

    echo "[$current_video/$num_videos] ${file:t} ($date) -> $resulting_file" | sed -E 's|/home/jayden|~|g'
    rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$file" "$resulting_file"

    ((current_video++))
done

echo
echo "================================================================"
echo "Imported $num_photos photos and $num_videos videos!"
echo "================================================================"
