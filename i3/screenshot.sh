#!/usr/bin/env bash

path=$HOME/Pictures/screenshots
file=$path/screenshot-`date +%s`.png

mkdir -p $path

case $1 in

  "output")
    gnome-screenshot -f $file
    ;;

  "area")
    gnome-screenshot -a -f $file
    ;;

  "window")
    gnome-screenshot -w -f $file
    ;;

esac

cat $file | xclip -selection clipboard -t image/png
