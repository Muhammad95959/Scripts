#!/bin/sh

i3-msg workspace "$(seq 1 10 | rofi -dmenu -no-custom -i -theme ~/.config/rofi/oneliner.rasi -p "open workspace:")"
