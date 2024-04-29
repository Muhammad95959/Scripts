#!/bin/bash

chosen=$(printf "\
Half-Life Source
Half-Life Blue Shift
Half-Life Opposing Force\
" | rofi -dmenu -i -theme ~/.config/rofi/games.rasi -p "choose a game: ")

case "$chosen" in
"Half-Life Source") cd "/mnt/Disk_D/Muhammad/Games/Half-Life Source" && wine "Half-Life Source.exe" ;;
"Half-Life Blue Shift") cd "/mnt/Disk_D/Muhammad/Games/Half-Life Blue Shift" && wine "hl.exe" ;;
"Half-Life Opposing Force") cd "/mnt/Disk_D/Muhammad/Games/Half-Life Opposing Force" && wine "hl.exe" ;;
esac
