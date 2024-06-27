#!/usr/bin/env bash

if [[ -z $1 ]]; then
    i3lock -n -e -f -c 111111
    exit 0
fi

wallpaper=$1
blurred=/tmp/blured_lock_wallpaper.png

yes | ffmpeg -i $wallpaper -vf "gblur=sigma=44:steps=6" $blurred
i3lock -n -e -f -t -i $blurred
