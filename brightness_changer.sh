#!/bin/sh

OLD_BRIT=$(brillo)

case $1 in
inc) brillo -A 5 ;;
dec) brillo -U 5 ;;
exp-inc) brillo -qA 2 ;;
exp-dec) brillo -qU 2 ;;
esac

BRIT=$(brillo)
if [ "$BRIT" != "$OLD_BRIT" ]; then
	volnoti-show "$BRIT" -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg
	OLD_BRIT=$BRIT
fi
