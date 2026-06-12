#!/bin/sh

browser="brave-origin"
history_file="/tmp/BraveHistory"
browser_history_path="$HOME/.config/BraveSoftware/Brave-Origin/Default/History"

# browser="helium-browser"
# history_file="/tmp/HeliumHistory"
# browser_history_path="$HOME/.config/net.imput.helium/Default/History"

cp "$browser_history_path" "$history_file"
cp "${browser_history_path}-journal" "${history_file}-journal" 2>/dev/null

selected_entry=$(sqlite3 -separator "  󰛂  " "$history_file" "SELECT title, url FROM urls ORDER BY last_visit_time DESC;" | rofi -dmenu -no-custom -i -p "History:")
selected_url=$(echo "$selected_entry" | awk -F '  󰛂  ' '{print $2}')

[ -n "$selected_url" ] && "$browser" --test-type --password-store=basic "$selected_url"
