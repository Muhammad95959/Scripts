#!/bin/bash

wallpapers_paths="/mnt/Disk_D/Backgrounds"
current_wallpaper_link="$HOME/.cache/${XDG_SESSION_TYPE}wall"
current_wallpaper=$(readlink "$current_wallpaper_link")
wallpapers_list=$(eval fd .jpg "$wallpapers_paths" | sed -E 's/ /\\r/g')
current_wallpaper_index=$(echo "$wallpapers_list" | grep -n "$current_wallpaper" | awk -F ':' '{print $1}')
selected_index=$(
  for a in $wallpapers_list; do
    printf '%s\0icon\x1f%s\n' "$(basename "$a")" "$a"
  done | rofi -dmenu -format i -theme ~/.config/rofi/wallpaper.rasi -theme-str "inputbar {background-image: url(\"$current_wallpaper\", width);}" -selected-row $((current_wallpaper_index - 1))
)
selected_wallpaper_path=$(echo "$wallpapers_list" | sed -n "$((selected_index + 1))p")

[ -z "$selected_index" ] && exit

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
  feh --no-fehbg --bg-fill "$selected_wallpaper_path"
  ln -fs "$selected_wallpaper_path" ~/.cache/x11wall
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  pgrep -x swww-daemon >/dev/null 2>&1 || setsid swww-daemon >/dev/null 2>&1 &
  swww img "$selected_wallpaper_path" --transition-type "fade" --transition-duration 1
  ln -fs "$selected_wallpaper_path" ~/.cache/waylandwall
fi
