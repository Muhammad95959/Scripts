#!/bin/sh

options="\
(a) 1600 x 900
(s) 1440 x 810
(d) 1280 x 720
(f) 960 x 600
(g) 840 x 525
(h) 800 x 450
(j) 640 x 360
(k) 480 x 270
(l) 432 x 243
(;) 320 x 180"

chosen=$(echo "$options" | rofi -dmenu -i -theme ~/.config/rofi/oneliner.rasi -p "choose the dimentions: ")

case "$chosen" in
"(a) 1600 x 900")  i3-msg floating enable && i3-msg resize set 1600 900  && i3-msg move position center ;;
"(s) 1440 x 810")  i3-msg floating enable && i3-msg resize set 1440 810  && i3-msg move position center ;;
"(d) 1280 x 720")  i3-msg floating enable && i3-msg resize set 1280 720  && i3-msg move position center ;;
"(f) 960 x 600")   i3-msg floating enable && i3-msg resize set 960 600   && i3-msg move position center ;;
"(g) 840 x 525")   i3-msg floating enable && i3-msg resize set 840 525   && i3-msg move position center ;;
"(h) 800 x 450")   i3-msg floating enable && i3-msg resize set 800 450   && i3-msg move position center ;;
"(j) 640 x 360")   i3-msg floating enable && i3-msg resize set 640 360   && i3-msg move position center ;;
"(k) 480 x 270")   i3-msg floating enable && i3-msg resize set 480 270   && i3-msg move position center ;;
"(l) 432 x 243")   i3-msg floating enable && i3-msg resize set 432 243   && i3-msg move position center ;;
"(;) 320 x 180")   i3-msg floating enable && i3-msg resize set 320 180   && i3-msg move position center ;;
esac
