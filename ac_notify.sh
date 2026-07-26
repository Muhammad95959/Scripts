#!/bin/bash

uid=$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"

APP_NAME="power"
ID=9999
TIMEOUT=5000

ICON_BASE="/usr/share/icons/Tela-circle-nord"
SOUND="/usr/share/sounds/freedesktop/stereo/message.oga"

makoctl dismiss -a "$APP_NAME"

show_help() {
  cat <<EOF
Usage: $0 <event> [percentage]

Events:
  plugged            Charger plugged in
  unplugged          Charger unplugged
  low <percent>      Low battery warning
  critical <percent> Critical battery warning
  full               Battery fully charged

Examples:
  $0 unplugged
  $0 plugged
  $0 low 15
  $0 critical 5
  $0 full
EOF
}

notify() {
  local title="$1"
  local body="$2"
  local icon="$3"
  local urgency="${4:-normal}"

  notify-send -a "$APP_NAME" \
    -r "$ID" \
    -t "$TIMEOUT" \
    -u "$urgency" \
    -i "$icon" \
    "$title" "$body"
}

case "$1" in
plugged)
  notify \
    "Charger Plugged In" \
    "AC power connected." \
    "$ICON_BASE/24/panel/battery-070-charging.svg"
  ;;

unplugged)
  notify \
    "Charger Unplugged" \
    "Running on battery now!" \
    "$ICON_BASE/symbolic/status/process-error-symbolic.svg"
  ;;

low)
  PERCENT="${2:-unknown}"
  notify \
    "Low Battery" \
    "Battery level is ${PERCENT}%." \
    "$ICON_BASE/24/panel/battery-020.svg" \
    "normal"
  ;;

critical)
  PERCENT="${2:-unknown}"
  notify \
    "Critical Battery" \
    "Battery critically low (${PERCENT}%). Plug in charger!" \
    "$ICON_BASE/24/panel/battery-empty.svg" \
    "critical"
  paplay "$SOUND" 2>/dev/null &
  ;;

full)
  notify \
    "Battery Full" \
    "You can unplug the charger." \
    "$ICON_BASE/24/panel/battery-100-charged.svg"
  ;;

-h | --help | "")
  show_help
  ;;

*)
  echo "Unknown option: $1"
  show_help
  exit 1
  ;;
esac
