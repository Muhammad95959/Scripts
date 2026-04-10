#!/bin/sh

chosen=$(printf '%s\n' "Tokyonight" "Catppuccin" "Embark" "Beige" |
  rofi -dmenu -no-custom -i -theme ~/.config/rofi/zathura_recolor.rasi -p "choose a theme: ")

[ -z "$chosen" ] && exit 1

if [ -f ~/.config/zathura/colors/"$chosen".conf ]; then
  cp ~/.config/zathura/colors/"$chosen".conf ~/.config/zathura/colors.conf
  sleep 0.3
  wtype ":source" -k return -k escape -s 25 -M ctrl r
fi
