#!/bin/sh

en_to_ar="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=en&tl=ar&op=translate"
ar_to_en="https://translate.google.com.eg/?hl=ar&tab=rT1&sl=ar&tl=en&op=translate"

text=$(
	rofi -dmenu \
		-p "Translate : " \
		-theme ~/.config/rofi/oneliner.rasi
)

if [ -z "$text" ]; then
	exit 1
fi

arabic_count=$(echo "$text" | grep -o -P "\p{Arabic}" | wc -l)
english_count=$(echo "$text" | grep -o -P "[A-Za-z]" | wc -l)

if [ "$arabic_count" -gt "$english_count" ]; then
	xdg-open "$ar_to_en&text=$text"
else
	xdg-open "$en_to_ar&text=$text"
fi
