#!/bin/sh

word=$(wl-paste -p)
[ -z "$word" ] && exit 1

if grep -q "$word" /mnt/Disk_D/Muhammad/NewEnglish.txt; then
  notify-send -t 2000 "\"$word\" already saved"
else
  echo "$word" >> /mnt/Disk_D/Muhammad/NewEnglish.txt
  notify-send -t 2000 "\"$word\" was added to the list"
fi
