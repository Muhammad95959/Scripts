#!/bin/bash

apps=$(ps -eo pid,%mem,comm --sort=-%mem | awk '{if ($1 != "PID") print $0}')
selected_app=$(printf '%s' "$apps" | rofi -dmenu -theme ~/.config/rofi/launcher.rasi)
selected_app_PID=$(echo "$selected_app" | awk '{print $1}')
selected_app_name=$(echo "$selected_app" | awk '{print $3}')

# List of app names to match
app_list=("pomatez" "thorium" "brave")

# Check if selected_app_name is in the list
if [[ " ${app_list[*]} " =~ $selected_app_name ]]; then
    killall "$selected_app_name"
else
    kill "$selected_app_PID"
fi
