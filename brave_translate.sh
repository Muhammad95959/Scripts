#!/bin/sh

browser_class="Brave-browser"
chromium_based_browser="brave"
brave_focused=false

if [ "$(xdotool getactivewindow getwindowclassname)" = "$browser_class" ]; then
  brave_focused=true
fi

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

if [ $brave_focused = true ]; then
  if [ "$arabic_count" -gt "$english_count" ]; then
    $chromium_based_browser "$ar_to_en&text=$text" --test-type >/dev/null 2>&1 &
  else
    $chromium_based_browser "$en_to_ar&text=$text" --test-type >/dev/null 2>&1 &
  fi
  exit 0
fi

if [ "$arabic_count" -gt "$english_count" ]; then
  nohup $chromium_based_browser "$ar_to_en&text=$text" --test-type --new-window >/dev/null 2>&1 &
else
  nohup $chromium_based_browser "$en_to_ar&text=$text" --test-type --new-window >/dev/null 2>&1 &
fi

while true; do
  if pgrep -x i3; then
    focusedClass=$(xprop -id "$(xdotool getwindowfocus)" | awk -F '"' '/WM_CLASS/{print $4}')
    if [ "$focusedClass" = "$browser_class" ]; then
      xdotool set_window --class "Brave-translate" "$(xdotool getactivewindow)"
      i3-msg floating enable, resize set 960 720, move position center
      xdotool key F11

      # Check if the window is in fullscreen_mode
      while true; do
        is_fullscreen=$(i3-msg -t get_tree | jq '.. | select(.focused?).fullscreen_mode')
        [ "$is_fullscreen" = "1" ] && xdotool key super+f && picom-trans -c 75 && break
        sleep 0.1
      done

      break
    fi
    sleep 0.1
  elif pgrep -x Hyprland; then
    focusedClass=$(hyprctl -j clients | jq -r '.[] | select(.focusHistoryID == 0) | .class')
    if [ "$focusedClass" = "$browser_class" ]; then
      hyprctl --batch "dispatch setfloating; dispatch resizeactive exact 960 720; dispatch centerwindow"
      ydotool key 87:1 87:0

      # Check if the window is in fullscreen_mode
      while true; do
        is_fullscreen=$(hyprctl -j clients | jq -r '.[] | select(.focusHistoryID == 0) | .fullscreen')
        [ "$is_fullscreen" = "2" ] && hyprctl dispatch fullscreen && hyprctl setprop active alpha 0.75 && break
        sleep 0.1
      done

      break
    fi
  fi
done
