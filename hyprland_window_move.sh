#!/bin/sh

direction="$1"
isFloating=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$isFloating" = "true" ]; then
  case "$direction" in
  l) hyprctl dispatch moveactive -20 0 ;;
  r) hyprctl dispatch moveactive 20 0 ;;
  u) hyprctl dispatch moveactive 0 -20 ;;
  d) hyprctl dispatch moveactive 0 20 ;;
  esac
else
  [ "$(hyprctl dispatch hy3:movewindow "$direction")" = "Invalid dispatcher" ] && hyprctl dispatch movewindow "$direction"
fi
