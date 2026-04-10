#!/bin/sh

configure_single_monitor() {
  hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
  hyprctl keyword monitor "HDMI-A-1,disable"
}

configure_dual_monitor() {
  hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
  hyprctl keyword monitor "HDMI-A-1,1366x768@60,1920x0,1"
}

get_connected_monitors() {
  hyprctl monitors -j | jq 'length'
}

wait_for_hdmi() {
  counter=0
  while [ "$counter" -le 10 ]; do
    counter=$((counter + 1))
    connected=$(get_connected_monitors)
    [ "$connected" -ge 2 ] && return 0
    echo "HDMI monitor not connected yet..."
    sleep 1
  done
  echo "HDMI monitor did not connect after waiting."
}

wait_for_hdmi

connected=$(get_connected_monitors)
case "$connected" in
1) configure_single_monitor ;;
2) configure_dual_monitor ;;
*) echo "More than two monitors connected. Adjust the script." ;;
esac
