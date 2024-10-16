#!/bin/sh

wlrctl pointer move -1920 -1080 || xdotool mousemove 0 0
virsh -c qemu:///system start "$1" && virt-manager --connect qemu:///system --show-domain-console "$1" || virsh -c qemu:///system destroy "$1"
