#!/bin/sh

get_duration() {
  ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$1" 2>/dev/null
}

[ "$#" -eq 0 ] && exit 1

total_duration=0

for path in "$@"; do
  if [ -f "$path" ]; then
    duration=$(get_duration "$path")
    [ -n "$duration" ] && total_duration=$(echo "$total_duration + $duration" | bc)
  fi
done

total_duration=$(echo "$total_duration / 1" | bc)

hours=$(echo "$total_duration / 3600" | bc)
minutes=$(echo "($total_duration % 3600) / 60" | bc)
seconds=$(echo "$total_duration % 60" | bc)

notify-send -t 7500 "$(printf "Duration: %02d:%02d:%02d\n" "$hours" "$minutes" "$seconds")"
