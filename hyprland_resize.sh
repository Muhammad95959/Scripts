#!/bin/sh

options="\
(a) 1800 x 825
(s) 1600 x 900
(d) 1280 x 720
(f) 960 x 600
(g) 840 x 525
(h) 800 x 450
(j) 640 x 360
(k) 480 x 270
(l) 432 x 243
(;) 320 x 180"

size=$(echo "$options" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/wayland/rofi/oneliner.rasi -p "choose the dimentions: " | awk '{print $2 " " $4}')
test -z "$size" || hyprctl --batch "dispatch setfloating; dispatch resizeactive exact $size; dispatch centerwindow"
