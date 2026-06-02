#!/bin/bash

DB="${XDG_DATA_HOME:-$HOME/.local/share}/zathura/bookmarks.sqlite"

file_path=$(
  sqlite3 "$DB" "SELECT file FROM fileinfo ORDER BY time DESC" |
    while read -r path; do [ -e "$path" ] && echo "$path"; done |
    rofi -dmenu -no-custom -i -p "Search:"
)

[ -n "$file_path" ] && setsid zathura "$file_path" >/dev/null 2>&1 &
