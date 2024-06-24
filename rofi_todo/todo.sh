#!/bin/sh

todolist_path="$HOME/Scripts/rofi_todo/todolist.txt"

options="\
  Add todo item
$(cat "$todolist_path")\
"

if pgrep -x waybar; then
	choice=$(echo "$options" | rofi -dmenu -i -p "Todo" -theme-str 'window {y-offset: -20px;}')
else
	choice=$(echo "$options" | rofi -dmenu -i -p "Todo")
fi

[ -z "$choice" ] && exit 1

case "$choice" in
"  Add todo item")
	if pgrep -x waybar; then
		item=$(rofi -dmenu -i -p "Todo Item : " -theme ~/.config/rofi/oneliner.rasi -theme-str 'window {y-offset: -20px;}')
	else
		item=$(rofi -dmenu -i -p "Todo Item : " -theme ~/.config/rofi/oneliner.rasi)
	fi
	[ -n "$item" ] && echo "$item" >>"$todolist_path"
	;;
*)
	sed -i "/$choice/d" "$todolist_path"
	;;
esac
