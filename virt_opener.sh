#!/bin/sh

xdotool mousemove 0 0
virsh -c qemu:///system start "$1" && virt-viewer -c qemu:///system "$1" || virsh -c qemu:///system destroy "$1"
