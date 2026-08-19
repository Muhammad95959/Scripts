#!/bin/sh
# rofi todo — add, toggle done, edit, delete, and clear completed items,
# all from a single rofi menu.
#
# Keybindings inside the list:
#   Enter    -> toggle done / add new item (if "Add new item" is selected)
#   Alt+e    -> edit selected item's text
#   Alt+d    -> delete selected item
#   Alt+c    -> clear all completed items
#   Alt+y    -> copy selected item to clipboard
#
# Storage format: one item per line, "<0|1><TAB><text>" where the leading
# digit is 0 = pending, 1 = done.

todolist_path="${TODO_FILE:-$HOME/Scripts/rofi_todo/todolist.txt}"
theme_dir="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
oneliner_theme="$theme_dir/oneliner.rasi"

mkdir -p "$(dirname "$todolist_path")"
touch "$todolist_path"

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send -t 2000 -a "Todo" "$1" "${2:-}" || true
}

# Migrate any pre-existing plain-text lines (no status column) to the
# "0<TAB>text" format so old todolist.txt files keep working.
migrate() {
  tmp=$(mktemp)
  awk -F'\t' 'NF<2 { print "0\t" $0; next } { print }' "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
}

add_item() {
  item=$(rofi -dmenu -i -p "New todo:" -theme "$oneliner_theme" </dev/null)
  [ -n "$item" ] && printf '0\t%s\n' "$item" >>"$todolist_path" && notify "Added" "$item"
}

toggle_item() {
  line_no="$1"
  tmp=$(mktemp)
  awk -F'\t' -v n="$line_no" 'BEGIN{OFS="\t"} NR==n{$1=($1=="1")?"0":"1"} {print}' \
    "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
}

delete_item() {
  line_no="$1"
  text=$(awk -F'\t' -v n="$line_no" 'NR==n{print $2}' "$todolist_path")
  tmp=$(mktemp)
  awk -v n="$line_no" 'NR!=n' "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
  notify "Deleted" "$text"
}

edit_item() {
  line_no="$1"
  old_text=$(awk -F'\t' -v n="$line_no" 'NR==n{print $2}' "$todolist_path")
  new_text=$(rofi -dmenu -i -p "Edit:" -filter "$old_text" -theme "$oneliner_theme" </dev/null)
  [ -z "$new_text" ] && return
  tmp=$(mktemp)
  awk -F'\t' -v n="$line_no" -v nt="$new_text" 'BEGIN{OFS="\t"} NR==n{$2=nt} {print}' \
    "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
}

clear_done() {
  tmp=$(mktemp)
  awk -F'\t' '$1!="1"' "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
  notify "Cleared completed items"
}

migrate

pending_count=$(awk -F'\t' '$1=="0"' "$todolist_path" | wc -l | tr -d ' ')

add_label="  Add new item"
menu=$(
  printf '%s\n' "$add_label"
  awk -F'\t' '{
		if ($1 == "1") printf "   󰄵  <s>%s</s>\n", $2
		else printf "   󰄱  %s\n", $2
	}' "$todolist_path"
)

selected=$(printf '%s' "$menu" | rofi -dmenu -i -markup-rows \
  -p "Todo ($pending_count)" \
  -mesg "Enter: toggle · Alt+e: edit · Alt+d: delete · Alt+c: clear done" \
  -kb-custom-1 "Alt+d" \
  -kb-custom-2 "Alt+e" \
  -kb-custom-3 "Alt+c" \
  -kb-custom-4 "Alt+y")
code=$?

[ -z "$selected" ] && exit 1

# Map the (markup-decorated) selected row back to its line number in the
# todo file, skipping the "Add new item" row.
line_no=$(awk -F'\t' -v sel="$selected" '
	{
		disp = ($1 == "1") ? "   󰄵  <s>" $2 "</s>" : "   󰄱  " $2
		if (disp == sel) { print NR; exit }
	}
' "$todolist_path")

case "$code" in
0) # Enter
  if [ "$selected" = "$add_label" ]; then
    add_item
  else
    [ -n "$line_no" ] && toggle_item "$line_no"
  fi
  ;;
10) # Alt+d - delete
  [ -n "$line_no" ] && delete_item "$line_no"
  ;;
11) # Alt+e - edit
  [ -n "$line_no" ] && edit_item "$line_no"
  ;;
12) # Alt+c - clear completed
  clear_done
  ;;
13) # Alt+y - yank to clipboard
  [ -n "$line_no" ] && awk -F'\t' -v n="$line_no" 'NR==n{print $2}' "$todolist_path" | wl-copy
  ;;
*)
  exit 1
  ;;
esac
