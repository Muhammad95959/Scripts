#!/bin/sh

sudo systemctl start libvirtd
sudo virsh net-start default

vms_names=$(sudo virsh list --all --name | sed '/^$/d')
vms_count=$(echo "$vms_names" | wc -l)
max_len=$(printf '%s\n' "$vms_names" | awk '{ if (length > max) max = length } END { print max }')
rofi_width=$((max_len + 15))

selected_vm=$(echo "$vms_names" | rofi -dmenu -theme ~/.config/rofi/script_chooser.rasi -p "Select VM: " -i -l "$vms_count" -theme-str "window { width: ${rofi_width}ch; }")

[ -z "$selected_vm" ] && exit 0

open_viewer() {
  SPICE_NOGRAB=1 virt-viewer --connect qemu:///system "$selected_vm" --full-screen &
}

vm_state=$(sudo virsh domstate "$selected_vm" 2>/dev/null)

if [ "$vm_state" = "running" ]; then
  action=$(printf "Force off\nShutdown\nOpen with virt-viewer\nOpen with virt-manager\n" |
    rofi -dmenu -theme ~/.config/rofi/script_chooser.rasi -p "${selected_vm} is running: " -i -l 4)

  case "$action" in
  "Force off")
    sudo virsh -c qemu:///system destroy "$selected_vm"
    ;;
  "Shutdown")
    sudo virsh -c qemu:///system shutdown "$selected_vm"
    ;;
  "Open with virt-viewer")
    open_viewer
    ;;
  "Open with virt-manager")
    virt-manager --connect qemu:///system --show-domain-console "$selected_vm" &
    ;;
  *)
    exit 0
    ;;
  esac
else
  if sudo virsh -c qemu:///system start "$selected_vm"; then
    open_viewer
  else
    notify-send "VM Launcher" "Failed to start $selected_vm"
  fi
fi
