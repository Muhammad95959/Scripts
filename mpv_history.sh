#!/bin/sh

selected=$(sed 's/^.*| //' "$HOME"/.config/mpv/history.log | rofi -dmenu -p "Select Video:")
[ -z "$selected" ] && exit
mpv "$selected" >/dev/null 2>&1 &
