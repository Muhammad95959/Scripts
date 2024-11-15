#!/bin/sh

if hyprctl -j clients | jq '.[] | select(.workspace.name == "special:magic")' -r | grep -q .; then
  echo "something"
  hyprctl dispatch togglespecialworkspace magic
else
  echo "nothing"
  hyprctl --batch "dispatch setfloating; dispatch centerwindow; dispatch movetoworkspace special:magic"
fi
