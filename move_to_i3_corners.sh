#!/bin/sh

# Get the screen dimensions
screen_width=1920
screen_height=1080

# Get the window ID of the currently focused window
window_id=$(xdotool getwindowfocus)

# Give some time for the window to change to floating mode
sleep 0.1

# Get the window dimensions
window_info=$(xwininfo -id "$window_id")
window_width=$(echo "$window_info" | awk '/Width:/ {print $2}')
window_height=$(echo "$window_info" | awk '/Height:/ {print $2}')

# Calculate the position

position_x=10
position_y=10

while true; do
  case $1 in
  topleft)
    break
    ;;
  topright)
    position_x=$((screen_width - window_width - 10))
    break
    ;;
  bottomleft)
    position_y=$((screen_height - window_height - 10))
    break
    ;;
  bottomright)
    position_x=$((screen_width - window_width - 10))
    position_y=$((screen_height - window_height - 10))
    break
    ;;
  *) set -- "$(printf "(1) topleft\n(2) topright\n(3) bottomleft\n(4) bottomright" | rofi -dmenu -i -theme ~/.config/rofi/oneliner.rasi -p "corner:" | awk '{print $2}')" ;;
  esac
done

# Move the focused window to the calculated position
i3-msg "[id=$window_id] floating enable, move position $position_x $position_y"
