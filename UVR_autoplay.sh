#!/bin/sh

inotifywait -m ~/Downloads -e create -e moved_to |
  while read -r file; do
    if expr "$file" : '.*\.wav$' >/dev/null; then
      if pgrep -x i3 >/dev/null 2>&1; then
        current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true).num')
        sleep 6
        i3-msg "workspace 9"
        sleep 0.3
        i3-msg "kill"
        sleep 0.3
        xdotool mousemove 960 535 click 1 sleep 0.02 mousemove restore
        sleep 0.3
        i3-msg "workspace $current_workspace"
      elif pgrep -x Hyprland >/dev/null 2>&1; then
        current_workspace=$(hyprctl activeworkspace | grep -o "([0-9].*)" | sed 's/[()]//g')
        sleep 6
        hyprctl dispatch workspace 9
        sleep 0.3
        hyprctl dispatch killactive
        sleep 0.3
        mouse_x_position=$(hyprctl cursorpos | sed 's/,//' | awk '{print $1}')
        mouse_y_position=$(hyprctl cursorpos | sed 's/,//' | awk '{print $2}')
        windows_count=$(hyprctl activeworkspace | grep -E "windows: [0-9]+" | awk '{print $2}')
        if [ "$windows_count" -eq 1 ]; then
          wlrctl pointer move -1920 -1080 && wlrctl pointer move 960 510
        else
          wlrctl pointer move -1920 -1080 && wlrctl pointer move 960 540
        fi
        wlrctl pointer click left && sleep 0.02
        wlrctl pointer move -1920 -1080 && wlrctl pointer move "$mouse_x_position" "$mouse_y_position"
        sleep 0.3
        hyprctl dispatch workspace "$current_workspace"
      fi
    fi
  done
