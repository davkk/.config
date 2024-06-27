#!/usr/bin/env bash

path=$HOME/Pictures/screenshots
file=$path/screenshot-`date +%s`.png

mkdir -p $path

if grimshot save $1 $file; then
    cat $file | wl-copy
    dunstify -u low "󰄀 Screenshot captured!" "$file"
else
    dunstify -u low "󰄀 Screenshot aborted!"
fi
