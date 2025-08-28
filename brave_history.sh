#!/bin/sh

if ! fuser ~/.config/BraveSoftware/Brave-Browser/Default/History >/dev/null 2>&1; then
  cp ~/.config/BraveSoftware/Brave-Browser/Default/History /tmp/BraveHistory
fi

HISTORY_FILE="/tmp/BraveHistory"
selected_entry=$(
  {
    echo "󰘳  Open Backup History"
    sqlite3 -separator "  󰛂  " "$HISTORY_FILE" \
      "SELECT title, url FROM urls ORDER BY last_visit_time DESC;"
  } | rofi -dmenu -no-custom -i -p "History:"
)

if [ "$selected_entry" = "󰘳  Open Backup History" ]; then
  HISTORY_FILE="/mnt/Disk_D/Muhammad/Linux_stuff/Backup/BraveHistoryArchive.db"
  selected_entry=$(sqlite3 -separator "  󰛂  " "$HISTORY_FILE" "SELECT title, url FROM urls ORDER BY last_visit_time DESC;" | rofi -dmenu -no-custom -i -p "Backup History:")
fi

selected_url=$(echo "$selected_entry" | awk -F '  󰛂  ' '{print $2}')
if [ -n "$selected_url" ]; then
  export XDG_CONFIG_HOME=
  brave --test-type "$selected_url"
fi
