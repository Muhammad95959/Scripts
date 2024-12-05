#!/bin/sh

OLD_BRIT=$(brightnessctl info | awk -F '[%(]' '/%/ {print $2}')

case $1 in
inc) brightnessctl set +5% ;;
dec) brightnessctl set 5%- ;;
exp-inc) brightnessctl set +1% ;;
exp-dec) brightnessctl set 1%- ;;
esac

BRIT=$(brightnessctl info | awk -F '[%(]' '/%/ {print $2}')
if [ "$BRIT" != "$OLD_BRIT" ]; then
	volnoti-show "$BRIT" -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg
	OLD_BRIT=$BRIT
fi
