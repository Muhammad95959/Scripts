#!/bin/sh

if test -f /tmp/smart_gaps_disabled; then
  hyprctl keyword plugin:hy3:no_gaps_when_only 1
  rm /tmp/smart_gaps_disabled
else
  hyprctl keyword plugin:hy3:no_gaps_when_only 0
  touch /tmp/smart_gaps_disabled
fi
