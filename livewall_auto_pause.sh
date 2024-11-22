#!/bin/sh

while true; do
  if pgrep -x mpvpaper >/dev/null 2>&1 && test -e /tmp/mpv-socket; then
    activeClass=$(hyprctl clients -j | jq '.[] | select(.focusHistoryID == 0) | .class')
    activeWorkspace=$(hyprctl monitors -j | jq '.[] | .activeWorkspace.id')
    workspaceWithFullscreen=$(hyprctl clients -j | jq '.[] | select(.fullscreen != 0) | .workspace.id')
    classesOnActiveWorkspace=$(hyprctl clients -j | jq -r --arg workspace_id "$activeWorkspace" '.[] | select(.floating == false) | select(.workspace.id == ($workspace_id | tonumber)) | .class')
    if test -n "$classesOnActiveWorkspace" && ! echo "$classesOnActiveWorkspace" | grep -Eq "(kitty|Yazi)"; then
      echo 'set pause yes' | socat - /tmp/mpv-socket
    elif [ "$workspaceWithFullscreen" = "$activeWorkspace" ] && ! echo "$activeClass" | grep -Eq "(kitty|Yazi)"; then
      echo 'set pause yes' | socat - /tmp/mpv-socket
    else
      echo 'set pause no' | socat - /tmp/mpv-socket
    fi
  fi
  sleep 1
done
