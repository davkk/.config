#!/usr/bin/env bash

min_brightness=0
fade_step_time=0.2

set_brightness() {
    light -S $1
}

fade_brightness() {
    light -S $1

    if [[ -z $fade_step_time ]]; then
        set_brightness $1
    else
        local level
        for level in $(eval echo {$(light)..$1}); do
            set_brightness $level
            sleep $fade_step_time
        done
    fi
}

trap 'exit 0' TERM INT
trap "set_brightness $(light); kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
