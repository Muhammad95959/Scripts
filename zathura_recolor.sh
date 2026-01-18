#!/bin/sh

chosen=$(printf '%s\n' "Tokyonight" "Catppuccin" "Embark" "Beige" |
  rofi -dmenu -no-custom -i -theme ~/.config/rofi/zathura_recolor.rasi -p "choose a theme: ")

[ -z "$chosen" ] && exit 1

if [ -f ~/.config/zathura/colors/"$chosen".conf ]; then
  cp ~/.config/zathura/colors/"$chosen".conf ~/.config/zathura/colors.conf

  sleep 0.3

  if [ "$(xdotool getactivewindow getwindowclassname)" = "Zathura" ]; then
    xdotool type ":"
    xdotool type "s"
    xdotool type "o"
    xdotool type "u"
    xdotool type "r"
    xdotool type "c"
    xdotool type "e"
    xdotool key Return
    xdotool key Escape
    xdotool key ctrl+r
  elif [ "$(hyprctl -j clients | jq -r '.[] | select(.focusHistoryID == 0) | .class')" = "org.pwmt.zathura" ]; then
    wtype ":source" -k return -k escape -s 25 -M ctrl r
  fi
fi
