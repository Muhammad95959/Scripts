#!/bin/sh

configure_single_monitor() {
	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --off --output DP-1-1 --off --output HDMI-1-0 --off
}

configure_dual_monitor() {
	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --off --output DP-1-1 --off --output HDMI-1-0 --mode 1366x768 --pos 1920x0 --rotate normal
	[ "$(pgrep -cx polybar)" -lt 2 ] && polybar -r secondary &
	nitrogen --restore
}

connected_monitors=$(xrandr --query | grep -c " connected")

wait_for_hdmi() {
	counter=0
	while [ "$counter" -le 10 ]; do
		counter=$((counter + 1))
		connected_monitors=$(xrandr --query | grep -c " connected")
		[ "$connected_monitors" = 2 ] && break
		echo "HDMI-1-0 is disconnected"
		sleep 1
	done
	echo "HDMI-1-0 did not connect after waiting."
}

wait_for_hdmi

case "$connected_monitors" in
1) configure_single_monitor ;;
2) configure_dual_monitor ;;
*) echo "More than two monitors are connected. Adjust the script to handle this setup." ;;
esac
