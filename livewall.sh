#!/bin/sh

if [ "$1" = "-f" ]; then
  if pgrep -x mpvpaper >/dev/null; then
    killall mpvpaper livewall_auto_pause.sh
    setsid swww-daemon >/dev/null 2>&1 &
  else
    pgrep -x swww-daemon >/dev/null && killall swww-daemon
    /usr/bin/mpvpaper eDP-1 -fo "input-ipc-server=/tmp/mpv-socket no-audio loop no-config" "/mnt/Disk_D/Backgrounds/Live/active"
    ~/Scripts/livewall_auto_pause.sh >/dev/null 2>&1 &
  fi
  exit 0
fi

change_wallpaper() {
  current_state=$(cat /sys/class/power_supply/*/online)
  if [ "$current_state" = 0 ]; then
    pgrep -x mpvpaper >/dev/null && killall mpvpaper livewall_auto_pause.sh
    setsid swww-daemon >/dev/null 2>&1 &
  elif [ "$current_state" = 1 ]; then
    pgrep -x swww-daemon >/dev/null && killall swww-daemon
    /usr/bin/mpvpaper eDP-1 -fo "input-ipc-server=/tmp/mpv-socket no-audio loop no-config" "/mnt/Disk_D/Backgrounds/Live/active"
    ~/Scripts/livewall_auto_pause.sh >/dev/null 2>&1 &
  fi
}

if ! [ -f /tmp/livewall.tmp ]; then
  cat /sys/class/power_supply/*/online >/tmp/livewall.tmp
  change_wallpaper
fi

while true; do
  echo "new loop"
  echo "$current_state" >/tmp/livewall.tmp
  [ "$(cat /sys/class/power_supply/*/online)" != "$(cat /tmp/livewall.tmp)" ] && change_wallpaper
  sleep 5
done
