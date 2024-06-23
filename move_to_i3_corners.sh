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

case $1 in
topleft) ;;
bottomleft) position_y=$((screen_height - window_height - 10)) ;;
topright) position_x=$((screen_width - window_width - 10)) ;;
bottomright)
	position_x=$((screen_width - window_width - 10))
	position_y=$((screen_height - window_height - 10))
	;;
*) echo "invalid command" && exit 1 ;;
esac

# Move the focused window to the calculated position
i3-msg "[id=$window_id] floating enable, move position $position_x $position_y"
