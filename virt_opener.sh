#!/bin/sh

sudo systemctl start libvirtd
sudo virsh net-start default

vms_names=$(sudo virsh list --all --name)
vms_count=$(echo "$vms_names" | wc -l)
max_len=$(printf '%s\n' "$vms_names" | awk '{ if (length > max) max = length } END { print max }')
rofi_width=$((max_len + 15))
selected_vm=$(echo "$vms_names" | rofi -dmenu -theme ~/.config/rofi/script_chooser.rasi -p "Select VM: " -i -l "$vms_count" -theme-str "window { width: ${rofi_width}ch; }")

if sudo virsh -c qemu:///system start "$selected_vm"; then
  SPICE_NOGRAB=1 virt-viewer --connect qemu:///system "$selected_vm" --full-screen
else
  sudo virsh -c qemu:///system destroy "$selected_vm"
fi
