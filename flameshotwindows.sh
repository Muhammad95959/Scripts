#!/bin/sh

# Click a window to select it, get its geometry via hyprctl
WINDOW=$(hyprctl activewindow -j)
X=$(echo "$WINDOW" | jq -r '.at[0]')
Y=$(echo "$WINDOW" | jq -r '.at[1]')
WIDTH=$(echo "$WINDOW" | jq -r '.size[0]')
HEIGHT=$(echo "$WINDOW" | jq -r '.size[1]')

REGION="${WIDTH}x${HEIGHT}+${X}+${Y}"
flameshot gui --region "$REGION"
