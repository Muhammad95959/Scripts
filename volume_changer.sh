#!/bin/sh

vol_inc() {
	current=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -m1 "" | sed "s/%.*//;s/.*\/.//")
	if [ "$current" -lt 146 ]; then
		pactl set-sink-mute @DEFAULT_SINK@ 0
		pactl set-sink-volume @DEFAULT_SINK@ +5%
	else
		pactl set-sink-volume @DEFAULT_SINK@ 150%
	fi
}

vol_dec() {
	pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5%
}

vol_small_inc() {
	current=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -m1 "" | sed "s/%.*//;s/.*\/.//")
	if [ "$current" -lt 150 ]; then
		pactl set-sink-mute @DEFAULT_SINK@ 0
		pactl set-sink-volume @DEFAULT_SINK@ +1%
	else
		pactl set-sink-volume @DEFAULT_SINK@ 150%
	fi
}

vol_small_dec() {
	pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -1%
}

toggle_vol_mute() {
	MAX_VOL=150
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	if pactl list sinks | grep -q "Mute: yes"; then
		volnoti-show -m
	else
		volnoti-show $(($(pactl list sinks | awk '/Volume: front-left/ {print $5}' | sed 's/%//') * 100 / MAX_VOL))
	fi
}

toggle_mic_mute() {
	amixer set Capture toggle
	if amixer get Capture | grep -Fq "[off]"; then
		volnoti-show 0 -s /usr/share/pixmaps/volnoti/mic_mute.svg
	else
		volnoti-show "$(amixer get Capture | grep -Po "[0-9]+(?=%)" | tail -1)" -s /usr/share/pixmaps/volnoti/mic.svg
	fi
}

case $1 in
vol_inc) vol_inc ;;
vol_dec) vol_dec ;;
vol_small_inc) vol_small_inc ;;
vol_small_dec) vol_small_dec ;;
toggle_vol_mute) toggle_vol_mute ;;
toggle_mic_mute) toggle_mic_mute ;;
esac
