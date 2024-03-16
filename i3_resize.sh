#!/bin/sh

options="\
1600 x 900
1440 x 810
1280 x 720
960 x 600
840 x 525
800 x 450
640 x 360
480 x 270
432 x 243
320 x 180"

chosen=$(echo "$options" | rofi -dmenu -i -theme ~/.config/rofi/oneliner.rasi -p "choose the dimentions: ")

case "$chosen" in
"1600 x 900")  i3-msg floating enable && i3-msg resize set 1600 900  && i3-msg move position center ;;
"1440 x 810")  i3-msg floating enable && i3-msg resize set 1440 810  && i3-msg move position center ;;
"1280 x 720")  i3-msg floating enable && i3-msg resize set 1280 720  && i3-msg move position center ;;
"960 x 600")   i3-msg floating enable && i3-msg resize set 960 600   && i3-msg move position center ;;
"840 x 525")   i3-msg floating enable && i3-msg resize set 840 525   && i3-msg move position center ;;
"800 x 450")   i3-msg floating enable && i3-msg resize set 800 450   && i3-msg move position center ;;
"640 x 360")   i3-msg floating enable && i3-msg resize set 640 360   && i3-msg move position center ;;
"480 x 270")   i3-msg floating enable && i3-msg resize set 480 270   && i3-msg move position center ;;
"432 x 243")   i3-msg floating enable && i3-msg resize set 432 243   && i3-msg move position center ;;
"320 x 180")   i3-msg floating enable && i3-msg resize set 320 180   && i3-msg move position center ;;
esac
