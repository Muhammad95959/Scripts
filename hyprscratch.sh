#!/bin/sh

scratchWindowsCount=$(hyprctl workspaces -j | jq '.[] | select(.name == "special:scratchpad") | .windows')
isFloating=$(hyprctl activewindow -j | jq '.floating')

if [ -z "$scratchWindowsCount" ]; then
  [ "$isFloating" = "false" ] && hyprctl --batch "dispatch setfloating; dispatch resizeactive exact 1280 720; dispatch centerwindow"
  scratchpad
  exit
fi

scratchpad -g -m "rofi -dmenu -p 'scratchpad: ' -theme ~/.config/rofi/script_chooser.rasi"
