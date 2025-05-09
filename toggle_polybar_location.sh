#!/bin/sh

if [ "$(grep 'bottom = true' ~/DotFiles/.config/polybar/config.ini)" != "" ]; then
	sed -Ei "/bottom = true/s/true/false/" ~/DotFiles/.config/polybar/config.ini
elif [ "$(grep 'bottom = true' ~/DotFiles/.config/polybar/config.ini)" = "" ]; then
	sed -Ei "/bottom = false/s/false/true/" ~/DotFiles/.config/polybar/config.ini
fi
