#!/bin/sh

if grep -q '^# hide_edge_borders.*###' ~/DotFiles/.config/i3/config; then
	sed -Ei '/smart_gaps.*###/s/^/# /' ~/DotFiles/.config/i3/config
	sed -Ei '/smart_borders.*###/s/^/# /' ~/DotFiles/.config/i3/config
	sed -Ei '/hide_edge_borders.*###/s/^# //' ~/DotFiles/.config/i3/config
	i3-msg restart
else
	sed -Ei '/smart_gaps.*###/s/^# //' ~/DotFiles/.config/i3/config
	sed -Ei '/smart_borders.*###/s/^# //' ~/DotFiles/.config/i3/config
	sed -Ei '/hide_edge_borders.*###/s/^/# /' ~/DotFiles/.config/i3/config
	i3-msg restart
fi
