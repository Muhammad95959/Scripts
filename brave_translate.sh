#!/bin/sh

browser_class="translate.google.com.eg"
chromium_based_browser="brave"

en_to_ar="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=en&tl=ar&op=translate"
ar_to_en="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=ar&tl=en&op=translate"

text=$(
  rofi -dmenu \
    -p "Translate : " \
    -theme "${XDG_CONFIG_HOME:-~/.config}"/rofi/oneliner.rasi
)

[ -z "$text" ] && exit 1

export XDG_CONFIG_HOME=

arabic_count=$(echo "$text" | grep -o -P "\p{Arabic}" | wc -l)
english_count=$(echo "$text" | grep -o -P "[A-Za-z]" | wc -l)

if [ "$arabic_count" -gt "$english_count" ]; then
  urlencode() {
    _str="$1"
    _str_len=${#_str}
    _pos=0
    while [ "$_pos" -lt "$_str_len" ]; do
      _c=$(printf '%s' "$_str" | cut -c "$((_pos + 1))")
      case "$_c" in
      [a-zA-Z0-9.~_-]) printf '%s' "$_c" ;;
      *) printf '%%%02X' "'$_c" ;;
      esac
      _pos=$((_pos + 1))
    done
  }
  encoded_text=$(urlencode "$text")
  nohup $chromium_based_browser "--app=$ar_to_en&text=$encoded_text" --test-type >/dev/null 2>&1 &
else
  nohup $chromium_based_browser "--app=$en_to_ar&text=$text" --test-type >/dev/null 2>&1 &
fi

if pgrep -x i3; then
  while true; do
    focusedClass=$(xprop -id "$(xdotool getwindowfocus)" | awk -F '"' '/WM_CLASS/{print $2}')
    if [ "$focusedClass" = "$browser_class" ]; then
      i3-msg floating enable, resize set 740 960, move position center
      picom-trans -c 75
      break
    fi
    sleep 0.1
  done
fi
