#!/bin/sh

todolist_path="$HOME/Scripts/rofi_todo/todolist.txt"

options="\
  Add todo item
$(cat "$todolist_path")\
"

choice=$(echo "$options" | rofi -dmenu -i -p "Todo")

case "$choice" in
  "  Add todo item")
    item=$(rofi -dmenu -i -p "Todo Item : " -theme ~/.config/rofi/oneliner.rasi)
    [ -n "$item" ] && echo "$item" >>"$todolist_path"
    ;;
  *)
    sed -i "/$choice/d" "$todolist_path"
    ;;
esac
