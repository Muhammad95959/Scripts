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
		-theme ~/.config/rofi/oneliner.rasi
)

[ -z "$text" ] && exit 1

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
	focusedClass=$(xprop -id "$(xdotool getwindowfocus)" | awk -F '"' '/WM_CLASS/{print $4}')
	if [ "$focusedClass" = "$browser_class" ]; then
		xdotool set_window --class "Brave-translate" "$(xdotool getactivewindow)"
		i3-msg floating enable && i3-msg resize set 960 720 && i3-msg move position center
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
done
