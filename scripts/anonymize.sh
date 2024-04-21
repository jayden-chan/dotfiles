#!/bin/zsh

full="no"
if [ "$1" = "--full" ]; then
    full="yes"
    shift
fi

num=0
for file in "$@"; do
    orientation=$(exiv2 -g 'Exif.Image.Orientation' -P v "$file")
    ext="${file:t:e}"

    new_name="${file:t:r}_clean.$ext"
    if [ "$full" = "yes" ]; then
        # create a pseudorandom name for the image while preserving the order of
        # the selected input files
        letter=$(cat /dev/urandom | tr -dc 'A-F' | fold -w 1 | head -n 1 | tr -d '\n')
        new_name="${num}${letter}$(cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 10 | head -n 1 | tr -d '\n').$ext"
        convert "$file" -resize "2000x2000>" "/tmp/$new_name"
    else
        cp "$file" "/tmp/$new_name"
    fi

    # strip all metadata from the image
    mat2 --inplace "/tmp/$new_name"

    # add back the image orientation metadata so that the image is rotated correctly
    exiv2 -M"set Exif.Image.Orientation Short $orientation" "/tmp/$new_name"

    mv "/tmp/$new_name" "$new_name"

    if [ "$full" = "yes" ]; then
        rm "$file"
    fi

    rm "/tmp/$new_name"
    ((num++))
done

notify-send "anonymize.sh" "Finished cleaning images"
