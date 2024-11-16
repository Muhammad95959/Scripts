#!/bin/sh

if hyprctl -j clients | jq '.[] | select(.workspace.name == "special:magic")' -r | grep -q .; then
  hyprctl dispatch togglespecialworkspace magic
else
  hyprctl --batch "dispatch setfloating; dispatch centerwindow; dispatch movetoworkspace special:magic"
fi
