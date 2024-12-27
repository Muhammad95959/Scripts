#!/bin/sh

chosen=$(printf "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "move to workspace:")
i3-msg move container to workspace number "$chosen", workspace number "$chosen"
