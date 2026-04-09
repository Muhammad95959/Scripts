#!/bin/sh

sudo systemctl start libvirtd
virsh -c qemu:///system start "$1" && SPICE_NOGRAB=1 virt-viewer --connect qemu:///system "$1" --full-screen || virsh -c qemu:///system destroy "$1"
