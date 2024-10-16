#!/bin/sh

# Path to Brave bookmarks file
BOOKMARKS_FILE="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"

# Temporary files to hold names and URLs
names_file=$(mktemp)
urls_file=$(mktemp)

# Get bookmark names and URLs using jq
jq -r '
    .roots.bookmark_bar.children[] |
    if .children then
        (.children[] | .name)
    else
        .name
    end' "$BOOKMARKS_FILE" >"$names_file"

jq -r '
    .roots.bookmark_bar.children[] |
    if .children then
        (.children[] | .url)
    else
        .url
    end' "$BOOKMARKS_FILE" >"$urls_file"

# Show bookmark names in rofi and capture the selected line
if pgrep waybar; then
  selected_name=$(rofi -dmenu -i -p "Bookmark:" -theme "$HOME/.config/rofi/launcher.rasi" <"$names_file")
else
  selected_name=$(rofi -dmenu -i -p "Bookmark:" -theme "$HOME/.config/rofi/oneliner.rasi" <"$names_file")
fi

# Get the corresponding URL based on the selected name
selected_url=$(awk -v name="$selected_name" '
    FNR==NR { names[FNR]=$0; next }
    { if (names[FNR] == name) print $0 }
' "$names_file" "$urls_file")

# If a URL was selected, open it in Brave
if [ -n "$selected_url" ]; then
  export XDG_CONFIG_HOME=
  brave --test-type "$selected_url"
fi

# Clean up temporary files
rm -f "$names_file" "$urls_file"
