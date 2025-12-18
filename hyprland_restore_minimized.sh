#!/bin/sh

# Current workspace ID
CURRENT_WS=$(hyprctl -j monitors |
  jq '.[] | select(.focused == true).activeWorkspace.id')

# Get list of special-workspace windows
WINDOWS=$(hyprctl -j clients |
  jq -r '.[] 
      | select(.workspace.name | startswith("special"))
      | "\(.address) ::: \(.title)"')

# Count them
COUNT=$(printf "%s\n" "$WINDOWS" | sed '/^$/d' | wc -l)

# No windows
if [ "$COUNT" -eq 0 ]; then
  notify-send -t 2500 "Hyprland" "No windows in the special workspace."
  exit 0
fi

# One window → auto bring it
if [ "$COUNT" -eq 1 ]; then
  ADDRESS=$(printf "%s" "$WINDOWS" | cut -d " " -f1)
  hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$ADDRESS"
  hyprctl dispatch focuswindow "address:$ADDRESS"
  exit 0
fi

# Multiple windows → show Rofi
CHOICE=$(printf "%s\n" "$WINDOWS" |
  rofi -dmenu \
    -theme ~/.config/rofi/arc_rounded.rasi \
    -theme-str "listview { lines: $COUNT; }" \
    -p "Window: ")

[ -z "$CHOICE" ] && exit 0

ADDRESS=$(printf "%s" "$CHOICE" | cut -d " " -f1)

# Move + focus
hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$ADDRESS"
hyprctl dispatch focuswindow "address:$ADDRESS"
