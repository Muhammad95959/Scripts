#!/bin/bash

# if xprop -id "$(xdotool getactivewindow)" | grep -q "YouTube"; then
# 	sleep 0.5
# 	xdotool key t
# 	sleep 0.5
# 	xdotool mousemove 960 975 click 1 sleep 0.02 mousemove restore
#   exit 0
# fi

window_class_name="$(xdotool getactivewindow getwindowclassname)"
case $window_class_name in
  "jetbrains-studio" | "jetbrains-idea-ce") xdotool mousemove 1885 978 click 1 sleep 0.02 mousemove restore ;;
  *) xdotool mousemove 1666 10 click 1 sleep 0.02 mousemove restore ;;
esac
