#!/bin/bash

uid=$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"

ID=9999

makoctl dismiss -a power

if [ "$1" == "unplugged" ]; then
  notify-send -a power -r "$ID" -t 5000 \
    "Charger Unplugged" "Running on battery now!" -i /usr/share/icons/Tela-circle-nord/symbolic/status/process-error-symbolic.svg
else
  notify-send -a power -r "$ID" -t 5000 \
    "Charger Plugged In" "AC power connected." -i /usr/share/icons/Tela-circle-nord/24/panel/battery-070-charging.svg
fi
