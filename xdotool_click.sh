#!/bin/bash

window_class_name="$(xdotool getactivewindow getwindowclassname)"
case $window_class_name in
    "jetbrains-studio" | "jetbrains-idea-ce") xdotool mousemove 1885 978 click 1 sleep 0.02 mousemove restore ;;
    *) xdotool mousemove 1655 10 click 1 sleep 0.02 mousemove restore ;;
esac
