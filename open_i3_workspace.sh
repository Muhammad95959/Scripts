#!/bin/sh

i3-msg workspace "$(seq 1 9 | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "open workspace:")"
