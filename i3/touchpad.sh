#!/usr/bin/env bash

touchpad=`xinput list --name-only | grep -i "touchpad" -m 1 | sed "s/^∼ \(.*\)/\1/"`

props=`xinput list-props "$touchpad"`
enabled=${1:-`xinput list-props "$touchpad" | grep -m 1 "Device Enabled" | sed -n 's/.*\([0-9]\)$/\1/p'`}

tapping=`xinput list-props "$touchpad"  | grep -m 1 "Tapping Enabled" | sed -n 's/.*(\([0-9]\+\)).*/\1/p'`
scrolling=`xinput list-props "$touchpad"  | grep -m 1 "Natural Scrolling Enabled" | sed -n 's/.*(\([0-9]\+\)).*/\1/p'`

case $enabled in

  0)
    # - enable touchpad
    xinput enable "$touchpad"
    # - enable tap-to-click
    xinput set-prop "$touchpad" $tapping 1
    # - enable natural scrolling
    xinput set-prop "$touchpad" $scrolling 1
    ;;

  1)
    # - enable touchpad
    xinput disable "$touchpad"
    ;;

  *)
    ;;

esac
