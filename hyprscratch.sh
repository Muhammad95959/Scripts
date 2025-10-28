#!/bin/sh

currentAddress=$(hyprctl activewindow -j | jq -r '.address')
[ -f /tmp/scratchpad ] && address=$(cat /tmp/scratchpad)

if [ "$1" = "-t" ]; then
  if [ "$currentAddress" = "$address" ]; then
    rm -f /tmp/scratchpad
  fi
  exit
fi

scratchWindowsCount=$(hyprctl workspaces -j | jq 'map(select(.name == "special:scratchpad"))[0].windows // 0')
isFloating=$(hyprctl activewindow -j | jq -r '.floating')

if [ -n "$address" ]; then
  windowExists=$(hyprctl clients -j | jq -e --arg addr "$address" 'map(select(.address == $addr)) | length > 0')
  if [ "$windowExists" = "true" ]; then
    echo "scratchpad already exists."
    workspaceWindowsCount=$(hyprctl activeworkspace -j | jq '.windows')
    [ "$currentAddress" = "$address" ] && [ "$workspaceWindowsCount" != "0" ] && scratchpad && exit
    workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    hyprctl dispatch movetoworkspacesilent "$workspace,address:$address"
    hyprctl dispatch focuswindow address:"$address"
    hyprctl dispatch alterzorder top, address:"$address"
    exit
  fi
fi

if [ "$scratchWindowsCount" = "0" ]; then
  [ "$isFloating" = "false" ] && hyprctl --batch "dispatch setfloating; dispatch resizeactive exact 1600 900; dispatch centerwindow"
  hyprctl activewindow -j | jq -r '.address' >/tmp/scratchpad
  scratchpad
else
  scratchpad -g -m "rofi -dmenu -p 'scratchpad: ' -theme ~/.config/rofi/script_chooser.rasi"
fi
