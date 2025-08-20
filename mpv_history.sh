#!/bin/sh

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    rofi_theme_arg="-theme"
    rofi_theme_path="$HOME/.config/rofi/wayland/rofi/config.rasi"
else
    rofi_theme_arg=""
    rofi_theme_path=""
fi

filtered=$(tac "$HOME"/.config/mpv/history.log | sed 's/^.*| //' | while read -r line; do
  [ -e "$line" ] && echo "$line"
done)
selected=$(echo "$filtered" | rofi -dmenu -i -p "Select Video:" "$rofi_theme_arg" "$rofi_theme_path")
[ -z "$selected" ] && exit
mpv "$selected" >/dev/null 2>&1 &
