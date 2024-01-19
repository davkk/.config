#!/usr/bin/env bash

path=$HOME/Pictures/screenshots
file=$path/screenshot-`date +%s`.png

mkdir -p $path
grimshot save $1 $file
cat $file | wl-copy
