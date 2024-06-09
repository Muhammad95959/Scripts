#!/bin/sh

MAX_VOL=150
OLD_VOL=$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | sed 's/\.//') * 100 / MAX_VOL))
pw-mon | grep --line-buffered "sink" |
while read -r _; do
	VOL=$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | sed 's/\.//') * 100 / MAX_VOL))
    if [ $VOL != $OLD_VOL ] && [ $VOL != 0 ]; then
      echo $VOL
		volnoti-show $VOL
		OLD_VOL=$VOL
    elif [ $VOL != $OLD_VOL ] && [ $VOL = 0 ]; then
        volnoti-show -m
		OLD_VOL=$VOL
	fi
done
