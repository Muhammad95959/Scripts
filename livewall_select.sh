#!/bin/sh

livewall_path="/mnt/Disk_D/Backgrounds/Live"
selected=$(find "$livewall_path" -type f ! -name "active" -exec basename {} \; | rofi -dmenu -p "Select Live Wallpaper")
export XDG_CONFIG_HOME=
[ -z "$selected" ] && exit
ln -frs "$livewall_path/$selected" "$livewall_path/active"
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  killall swww-daemon mpvpaper livewall_auto_pause.sh
  mpvpaper eDP-1 -fo "input-ipc-server=/tmp/mpv-socket no-audio loop no-config" "/mnt/Disk_D/Backgrounds/Live/active"
  ~/Scripts/livewall_auto_pause.sh >/dev/null 2>&1 &
fi
