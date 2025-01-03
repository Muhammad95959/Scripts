#!/bin/sh

file_paths=$(sqlite3 "${XDG_DATA_HOME:-$HOME/.local/share}/zathura/bookmarks.sqlite" "SELECT file FROM fileinfo ORDER BY time DESC" |
	while read -r path; do
		[ -e "$path" ] && echo "$path"
	done | rofi -dmenu -no-custom -i -p "Search:")

export XDG_CONFIG_HOME=

if [ -n "$file_paths" ]; then
	setsid zathura "$file_paths" >/dev/null 2>&1 &
fi
