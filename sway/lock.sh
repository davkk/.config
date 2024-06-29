#!/usr/bin/env bash

# if [[ -z $1 ]]; then
#     swaylock -f -c 111111 -s fill
#     exit 0
# fi

# wallpaper=$1
blurred=/tmp/blured_lock_wallpaper.jpg

grim - | ffmpeg -y -i pipe: -vf "gblur=sigma=50:steps=6,eq=brightness=0.03" $blurred
swaylock -f -i $blurred -s fill
rm $blurred
