#!/bin/bash

# This script was named after the first browser it was made for which is thorium-browser
# but that browser could be changed very easily by changing the following declarations
browser_class="Thorium-browser"
chromium_based_browser="thorium-browser"

if [[ $(xdotool getactivewindow getwindowclassname) == "$browser_class" ]]; then
	notify-send "Error" "This script is not compatible with $browser_class as the active window class."
	exit 1
fi

en_to_ar="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=en&tl=ar&op=translate"
ar_to_en="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=ar&tl=en&op=translate"

text=$(
	rofi -dmenu \
		-p "Translate : " \
		-theme ~/.config/rofi/oneliner.rasi
)

if [ -z "$text" ]; then
	exit 2
fi

arabic_count=$(echo "$text" | grep -o -P "\p{Arabic}" | wc -l)
english_count=$(echo "$text" | grep -o -P "[A-Za-z]" | wc -l)

if [ "$arabic_count" -gt "$english_count" ]; then
	nohup $chromium_based_browser "$ar_to_en&text=$text" --test-type --new-window &>/dev/null &
else
	nohup $chromium_based_browser "$en_to_ar&text=$text" --test-type --new-window &>/dev/null &
fi

while true; do
	focusedClass=$(xprop -id "$(xdotool getwindowfocus)" | awk -F '"' '/WM_CLASS/{print $4}')
	if [ "$focusedClass" == "$browser_class" ]; then
		xdotool set_window --class "Thorium-translate" "$(xdotool getactivewindow)"
		i3-msg floating enable && i3-msg resize set 960 720 && i3-msg move position center
		xdotool key F11

		# Check if the window is in fullscreen_mode
		while true; do
			is_fullscreen=$(i3-msg -t get_tree | jq '.. | select(.focused?).fullscreen_mode')
			[ "$is_fullscreen" == "1" ] && xdotool key super+f && picom-trans -c 75 && break
			sleep 0.1
		done

		break
	fi
	sleep 0.1
done
