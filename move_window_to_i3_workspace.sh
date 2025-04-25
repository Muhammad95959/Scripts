#!/bin/sh

chosen=$(seq 1 10 | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "move to workspace:")
i3-msg move container to workspace number "$chosen", workspace number "$chosen"
