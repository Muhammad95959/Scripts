#!/bin/sh

wallpapers_paths="/mnt/Disk_D/Backgrounds"
wallpapers_list=$(eval fd .jpg "$wallpapers_paths" -E brave | sed -E 's/ /\\r/g')
[ -f "$HOME/.cache/${XDG_SESSION_TYPE}wall" ] || ln -fs "$(echo "$wallpapers_list" | sed -n "1p")" "$HOME/.cache/${XDG_SESSION_TYPE}wall"
current_wallpaper=$(readlink "$HOME/.cache/${XDG_SESSION_TYPE}wall")
current_wallpaper_index=$(echo "$wallpapers_list" | grep -n "$current_wallpaper" | awk -F ':' '{print $1}')
selected_index=$(
  echo "$wallpapers_list" | awk -F '\\r' '{
    path=$0; name=path; sub(".*/", "", name); printf "%s\0icon\x1f%s\n", name, path
  }' | rofi -dmenu -format i -theme ~/.config/rofi/wallpaper.rasi -theme-str "inputbar {background-image: url(\"$current_wallpaper\", width);}" -selected-row $((current_wallpaper_index - 1))
)
selected_wallpaper_path=$(echo "$wallpapers_list" | sed -n "$((selected_index + 1))p")

[ -z "$selected_index" ] && exit

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
  feh --no-fehbg --bg-fill "$selected_wallpaper_path"
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  pgrep -x swww-daemon >/dev/null 2>&1 || setsid swww-daemon >/dev/null 2>&1 &
  swww img "$selected_wallpaper_path" --transition-type "none" --transition-duration 0
fi

ln -fs "$selected_wallpaper_path" "$HOME/.cache/${XDG_SESSION_TYPE}wall"
magick "$HOME/.cache/${XDG_SESSION_TYPE}wall" -gravity center -crop 1:1 +repage ~/.cache/rofiwall
