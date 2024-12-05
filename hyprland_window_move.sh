#!/bin/sh

isFloating=$(hyprctl clients -j | jq '.[] | select(.focusHistoryID == 0) | .floating')
[ "$isFloating" = "false" ] && [ "$(hyprctl dispatch hy3:movewindow "$1")" = "Invalid dispatcher" ] && hyprctl dispatch movewindow "$1"
