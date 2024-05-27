#!/bin/sh

number=$(
	rofi -dmenu \
		-p "The number of UVR instances to open : " \
		-theme ~/.config/rofi/oneliner.rasi
)

if ! expr "$number" : '^[1-9][0-9]*$'; then
	notify-send -t 3000 "Invalid input. Please enter a number greater than 0."
	exit 1
fi

i=0
while [ "$i" -lt "$number" ]; do
	prime-run /mnt/Disk_D/برامج/Linux/ultimatevocalremovergui/python3.10_environment/bin/python3 /mnt/Disk_D/برامج/Linux/ultimatevocalremovergui/UVR.py >/dev/null 2>&1 &
	i=$((i + 1))
done
