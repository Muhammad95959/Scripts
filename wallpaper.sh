#!/bin/bash

wallpapers_path="/mnt/Disk_D/Backgrounds"
current_wallpaper="$HOME/.cache/${XDG_SESSION_TYPE}wall"
selected=$(
  for a in $(fd .jpg $wallpapers_path --max-depth 1); do
    echo -en "$(basename "$a")\0icon\x1f$a\n"
  done | rofi -dmenu -theme ~/.config/rofi/wallpaper.rasi -theme-str "inputbar {background-image: url(\"$current_wallpaper\", width);}"
)

[ -z "$selected" ] && exit

if [ "$XDG_SESSION_TYPE" = "x11" ];then
  feh --bg-fill "$wallpapers_path/$selected"
  ln -fs "$wallpapers_path/$selected" ~/.cache/x11wall
elif [ "$XDG_SESSION_TYPE" = "wayland" ];then
  pgrep -x swww-daemon >/dev/null 2>&1 || setsid swww-daemon >/dev/null 2>&1 &
  swww img "$wallpapers_path/$selected" --transition-type "fade" --transition-duration 1
  ln -fs "$wallpapers_path/$selected" ~/.cache/waylandwall
fi
