#!/usr/bin/env bash

if [[ -z $1 ]]; then
    swaylock -f -c 111111 -s fill
    exit 0
fi

wallpaper=$1
blurred=/tmp/blured_lock_wallpaper.jpg

yes | ffmpeg -i $wallpaper -vf "gblur=sigma=44:steps=6" $blurred
swaylock -f -i $blurred -s fill
