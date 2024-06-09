#!/bin/sh

if [ "$(waydroid status | awk '/Session:/ {print $2}')" = "STOPPED" ]; then
	cage -- waydroid show-full-ui
else
	sudo waydroid session stop && sudo waydroid container stop
fi
