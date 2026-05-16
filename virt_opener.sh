#!/bin/sh

sudo systemctl start libvirtd
sudo virsh net-start default

if sudo virsh -c qemu:///system start "$1"; then
  SPICE_NOGRAB=1 virt-viewer --connect qemu:///system "$1" --full-screen
else
  sudo virsh -c qemu:///system destroy "$1"
fi
