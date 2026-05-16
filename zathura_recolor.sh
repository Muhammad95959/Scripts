#!/bin/sh

chosen=$(
  count=0
  names=""
  for f in ~/.config/zathura/colors/*.conf; do
    [ -e "$f" ] || continue
    name=$(basename "${f%.conf}")
    names="${names}${name}\n"
    count=$((count + 1))
  done
  printf "%b" "$names" | rofi -dmenu -no-custom -i \
    -lines "$count" \
    -theme ~/.config/rofi/zathura_recolor.rasi \
    -p "choose a theme: "
)

[ -z "$chosen" ] && exit 1

if [ -f ~/.config/zathura/colors/"$chosen".conf ]; then
  cp ~/.config/zathura/colors/"$chosen".conf ~/.config/zathura/colors.conf
  sleep 0.3
  wtype ":source" -k return -k escape -s 25 -M ctrl r
fi
