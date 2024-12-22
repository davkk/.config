#!/usr/bin/env bash

if [[ `powerprofilesctl get` != 'power-saver' ]]; then
    exit 0
fi

light -O

min_brightness=0
fade_step_time=0.01

initial_light=`light | awk -F'.' '{print $1}'`
for level in $(eval echo {$initial_light..$min_brightness}); do
    light -S $level
    sleep $fade_step_time
done
