#!/usr/bin/env bash

path=$HOME/Pictures/screenshots
file=$path/screenshot-`date +%s`.png

mkdir -p $path
grimshot save $1 $file
cat $file | wl-copy

dunstify -u low -r 2001 "󰄀 Screenshot captured!" "$1"
