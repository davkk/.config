#!/usr/bin/env bash

wallpaper=$1
blurred=/tmp/blured_lock_wallpaper.png

yes | ffmpeg -i $wallpaper -vf "gblur=sigma=44:steps=6" $blurred
i3lock -n -e -f -i $blurred
