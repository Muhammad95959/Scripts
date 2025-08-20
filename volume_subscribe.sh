#!/bin/sh

MAX_VOL=150
OLD_VOL=$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}') * 100 / MAX_VOL))
pw-mon | grep --line-buffered "sink" |
  while read -r _; do
    UNFORMATTED_VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    VOL=$((UNFORMATTED_VOL * 100 / MAX_VOL))
    [ "$UNFORMATTED_VOL" -eq 153 ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.5 && continue
    if [ $VOL != $OLD_VOL ] && [ $VOL != 0 ]; then
      echo $VOL
      volnoti-show $VOL
      OLD_VOL=$VOL
    elif [ $VOL != $OLD_VOL ] && [ $VOL = 0 ]; then
      volnoti-show -m
      OLD_VOL=$VOL
    fi
  done
