#!/bin/sh

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  focused_window_title=$(hyprctl -j clients | jq -r '.[] | select(.focusHistoryID == 0) | .title')
else
  focused_window_title=$(xdotool getwindowfocus getwindowname)
fi
if [ "$focused_window_title" = "Albert" ]; then
  rofi -show drun -theme ~/.config/rofi/arc_rounded.rasi
else
  if pgrep -x albert >/dev/null 2>&1; then
    albert toggle
  else
    albert
  fi
fi
