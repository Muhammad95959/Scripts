#!/bin/sh

screen_width=1920
screen_height=1080

[ -z "$1" ] && set -- "$(printf "(1) topleft\n(2) topright\n(3) bottomleft\n(4) bottomright" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "corner:" | awk '{print $2}')"

[ -z "$1" ] && exit 0

window_address=$(hyprctl activewindow -j | jq -r '.address')

hyprctl dispatch 'hl.dsp.window.float({ action = "on" })'

position_x=10
position_y=30

window_width=$(hyprctl clients -j | jq --arg addr "$window_address" '.[] | select(.address == $addr) | .size[0]')
window_height=$(hyprctl clients -j | jq --arg addr "$window_address" '.[] | select(.address == $addr) | .size[1]')

case $1 in
topleft) ;;
topright) position_x=$((screen_width - window_width - 10)) ;;
bottomleft) position_y=$((screen_height - window_height - 10)) ;;
bottomright)
  position_x=$((screen_width - window_width - 10))
  position_y=$((screen_height - window_height - 10))
  ;;
esac

hyprctl dispatch 'hl.dsp.window.move({ x = '"$position_x"', y = '"$position_y"' })'
