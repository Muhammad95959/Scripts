#!/bin/sh

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  focused_window_title=$(hyprctl -j clients | jq -r '.[] | select(.focusHistoryID == 0) | .title')
else
  focused_window_title=$(xdotool getwindowfocus getwindowname)
fi
if [ "$focused_window_title" = "Ulauncher - Application Launcher" ]; then
  rofi -show drun -theme ~/.config/rofi/launcher.rasi
else
  if pgrep -x ulauncher >/dev/null 2>&1; then
    ulauncher-toggle
  else
    ulauncher
  fi
fi
