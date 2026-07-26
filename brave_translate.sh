#!/bin/sh

chromium_based_browser="brave-origin"

en_to_ar="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=en&tl=ar&op=translate"
ar_to_en="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=ar&tl=en&op=translate"

text=$(
  rofi -dmenu \
    -p "Translate : " \
    -theme "${XDG_CONFIG_HOME:-~/.config}"/rofi/oneliner.rasi
)

[ -z "$text" ] && exit 1

arabic_count=$(echo "$text" | grep -o -P "\p{Arabic}" | wc -l)
english_count=$(echo "$text" | grep -o -P "[A-Za-z]" | wc -l)

if [ "$arabic_count" -gt "$english_count" ]; then
  urlencode() {
    printf '%s' "$1" | od -An -tx1 | tr ' ' '\n' | grep -v '^$' | while read -r hex; do
      printf '%%%s' "$hex" | tr 'a-f' 'A-F'
    done
  }
  encoded_text=$(urlencode "$text")
  nohup $chromium_based_browser "--app=$ar_to_en&text=$encoded_text" --test-type --password-store=basic >/dev/null 2>&1 &
else
  nohup $chromium_based_browser "--app=$en_to_ar&text=$text" --test-type --password-store=basic >/dev/null 2>&1 &
fi
