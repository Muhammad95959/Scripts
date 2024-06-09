#!/bin/sh

vol_inc() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
}

vol_dec() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
}

vol_small_inc() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+
}

vol_small_dec() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
}

toggle_vol_mute() {
	MAX_VOL=150
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -iq "muted"; then
		volnoti-show -m
	else
		volnoti-show $(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | sed 's/\.//') * 100 / MAX_VOL))
	fi
}

toggle_mic_mute() {
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
	if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -iq "muted"; then
		volnoti-show 0 -s /usr/share/pixmaps/volnoti/mic_mute.svg
	else
		volnoti-show "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2 * 100}' | sed 's/\.//')" -s /usr/share/pixmaps/volnoti/mic.svg
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
