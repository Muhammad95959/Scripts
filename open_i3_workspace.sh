#!/bin/sh

i3-msg workspace "$(printf "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "open workspace:")"
