#!/usr/bin/env bash

min_brightness=0
fade_step_time=0.01

if [[ -z $fade_step_time ]]; then
    light -S $1
else
    local level
    initial_light=`light | awk -F'.' '{print $1}'`
    for level in $(eval echo {$initial_light..$1}); do
        light -S $1
        sleep $fade_step_time
    done
fi
