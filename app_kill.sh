#!/bin/sh

apps=$(ps -eo pid,%mem,comm --sort=-%mem | awk '{if ($1 != "PID") print $0}')
selected_app=$(printf '%s' "$apps" | rofi -dmenu -theme ~/.config/rofi/launcher.rasi)
selected_app_PID=$(echo "$selected_app" | awk '{print $1}')
selected_app_name=$(echo "$selected_app" | awk '{print $3}')

# List of app names to match
app_list="pomatez thorium brave teams electron node"

# Check if selected_app_name is in the list
case " $app_list " in
*"$selected_app_name"*) killall "$selected_app_name" ;;
*) kill "$selected_app_PID" ;;
esac
