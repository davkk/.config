#!/usr/bin/env bash

blurred=/tmp/blured_lock_wallpaper.jpg

grim - | ffmpeg -y -i pipe: -vf "gblur=sigma=50:steps=6,eq=brightness=0.03" $blurred

if [[ -f $blurred ]]; then
    swaylock -f -i $blurred -s fill
    rm $blurred
else
    swaylock -f -c 111111 -s fill
fi
