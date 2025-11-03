#!/bin/sh

# Get the screen dimensions
screen_width=1920
screen_height=1080

[ -z "$1" ] && set -- "$(printf "(1) topleft\n(2) topright\n(3) bottomleft\n(4) bottomright" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/wayland/rofi/oneliner.rasi -p "corner:" | awk '{print $2}')"

# Get the window ID of the currently focused window
window_address=$(hyprctl activewindow -j | jq -r '.address')

# Make the window floating
[ -n "$1" ] && hyprctl dispatch setfloating address:"$window_address" && hyprctl dispatch centerwinon address:"$window_address"

# Calculate the position
position_x=10
position_y=30

# Get the window dimensions
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

[ -n "$1" ] && hyprctl dispatch movewindowpixel exact "$position_x" "$position_y",address:"$window_address"
