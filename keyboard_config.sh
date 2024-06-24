#!/bin/sh

sudo udevmon &
xset r rate 240 42
setxkbmap -layout "us,eg" -option "lv3:ralt_alt,grp:alt_shift_toggle"
