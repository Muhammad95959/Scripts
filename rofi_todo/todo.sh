#!/bin/sh
# rofi todo — add, toggle done, edit, delete, move, and clear completed
# items, all from a single rofi menu.
#
# Keybindings inside the list:
#   Enter    -> toggle done / add new item (if "Add new item" is selected)
#   Alt+e    -> edit selected item's text
#   Alt+d    -> delete selected item
#   Alt+c    -> clear all completed items
#   Alt+y    -> copy selected item to clipboard
#   Alt+j    -> move selected item down
#   Alt+k    -> move selected item up
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

# Escape characters that are special in pango markup so user text can't be
# misinterpreted as tags (e.g. an item containing "<" or "&").
escape_pango() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

add_item() {
  item=$(rofi -dmenu -i -p "New todo:" -theme "$oneliner_theme" \
    -theme-str 'mainbox { children: [ inputbar ]; } inputbar { width: 100%; }' </dev/null)
  [ -z "$item" ] && return
  item=$(printf '%s' "$item" | tr '\t' ' ')
  printf '0\t%s\n' "$item" >>"$todolist_path" && notify "Added" "$item"
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
  new_text=$(rofi -dmenu -i -p "Edit:" -filter "$old_text" -theme "$oneliner_theme" \
    -theme-str 'mainbox { children: [ inputbar ]; } inputbar { width: 100%; }' </dev/null)
  [ -z "$new_text" ] && return
  new_text=$(printf '%s' "$new_text" | tr '\t' ' ')
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

# Each move function sets new_row to the 0-based menu row the item landed on
# (or leaves it empty when no move happened) so the menu can re-select it.
move_up() {
  n="$1"
  new_row=""
  [ "$n" -le 1 ] && return
  tmp=$(mktemp)
  awk -v n="$n" '{ l[NR]=$0 } END{ t=l[n]; l[n]=l[n-1]; l[n-1]=t; for(i=1;i<=NR;i++) print l[i] }' \
    "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
  new_row=$((n - 1))
}

move_down() {
  n="$1"
  new_row=""
  total=$(wc -l < "$todolist_path" | tr -d ' ')
  [ "$n" -ge "$total" ] && return
  tmp=$(mktemp)
  awk -v n="$n" '{ l[NR]=$0 } END{ t=l[n]; l[n]=l[n+1]; l[n+1]=t; for(i=1;i<=NR;i++) print l[i] }' \
    "$todolist_path" >"$tmp"
  mv "$tmp" "$todolist_path"
  new_row=$((n + 1))
}

migrate

add_label="  Add new item"

while true; do
  pending_count=$(awk -F'\t' '$1=="0"' "$todolist_path" | wc -l | tr -d ' ')

  menu=$(
    printf '%s\n' "$add_label"
    awk -F'\t' '{
      t = $2
      gsub(/&/, "\\&amp;", t)
      gsub(/</, "\\&lt;", t)
      gsub(/>/, "\\&gt;", t)
      if ($1 == "1") printf "   󰄵  <s>%s</s>\n", t
      else printf "   󰄱  %s\n", t
    }' "$todolist_path"
  )

  # -format d makes rofi return the 1-based index of the selected row, so we
  # can map straight to a line number without fragile text matching.
  # -selected-row keeps the just-moved item highlighted after a refresh.
  selected=$(printf '%s' "$menu" | rofi -dmenu -i -markup-rows -format d \
    -selected-row "${preselect:-0}" \
    -p "Todo ($pending_count)" \
    -mesg "Enter: toggle · Alt+e: edit · Alt+d: delete · Alt+c: clear · Alt+y: copy · Alt+j/k: move" \
    -kb-custom-1 "Alt+d" \
    -kb-custom-2 "Alt+e" \
    -kb-custom-3 "Alt+c" \
    -kb-custom-4 "Alt+y" \
    -kb-custom-5 "Alt+j" \
    -kb-custom-6 "Alt+k")
  code=$?

  [ -z "$selected" ] && exit 1

  index="$selected"
  # Row 1 is the "Add new item" label; everything after maps to a file line.
  line_no=$((index - 1))

  case "$code" in
  0) # Enter
    if [ "$index" = "1" ]; then
      add_item
      preselect=0
    else
      if [ "$line_no" -ge 1 ]; then
        toggle_item "$line_no"
        preselect="$line_no"
      fi
    fi
    continue
    ;;
  10) # Alt+d - delete
    [ "$index" != "1" ] && delete_item "$line_no"
    break
    ;;
  11) # Alt+e - edit
    [ "$index" != "1" ] && edit_item "$line_no"
    break
    ;;
  12) # Alt+c - clear completed
    clear_done
    break
    ;;
  13) # Alt+y - yank to clipboard
    if [ "$index" != "1" ]; then
      text=$(awk -F'\t' -v n="$line_no" 'NR==n{print $2}' "$todolist_path")
      printf '%s' "$text" | wl-copy
      notify "Copied to clipboard" "$text"
    fi
    break
    ;;
  14) # Alt+j - move down
    [ "$index" != "1" ] && { move_down "$line_no"; preselect="$new_row"; }
    continue
    ;;
  15) # Alt+k - move up
    [ "$index" != "1" ] && { move_up "$line_no"; preselect="$new_row"; }
    continue
    ;;
  *)
    exit 1
    ;;
  esac
done
