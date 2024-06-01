#!/bin/sh

MAX_VOL=150
OLD_VOL=$(($(pactl list sinks | awk '/^[[:space:]]Volume:/ {print $5}' | tail -1 | sed 's/%//')*100/MAX_VOL))
pactl subscribe | grep --line-buffered "sink" |
while read -r _; do
	VOL=$(($(pactl list sinks | awk '/^[[:space:]]Volume:/ {print $5}' | tail -1 | sed 's/%//')*100/MAX_VOL))
    if [ $VOL != $OLD_VOL ] && [ $VOL != 0 ]; then
      echo $VOL
		volnoti-show $VOL
		OLD_VOL=$VOL
    elif [ $VOL != $OLD_VOL ] && [ $VOL = 0 ]; then
        volnoti-show -m
		OLD_VOL=$VOL
	fi
done
