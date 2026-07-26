#!/bin/sh

todolist_path="$HOME/Scripts/rofi_todo/todolist.txt"

options="\
  Add todo item
$(cat "$todolist_path")\
"

choice=$(echo "$options" | rofi -dmenu -no-custom -i -p "Todo")

[ -z "$choice" ] && exit 1

case "$choice" in
"  Add todo item")
	item=$(rofi -dmenu -i -p "Todo Item : " -theme "${XDG_CONFIG_HOME:-$HOME/.config}"/rofi/oneliner.rasi)
	[ -n "$item" ] && echo "$item" >>"$todolist_path"
	;;
*)
	sed -i "/$choice/d" "$todolist_path"
	;;
esac
