#!/bin/sh

filtered=$(tac "$HOME"/.config/mpv/history.log | sed 's/^.*| //' | while read -r line; do
  [ -e "$line" ] && echo "$line"
done)
selected=$(echo "$filtered" | rofi -dmenu -p "Select Video:")
[ -z "$selected" ] && exit
mpv "$selected" >/dev/null 2>&1 &
