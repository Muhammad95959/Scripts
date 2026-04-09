#!/bin/sh

set -eu

DEST="/mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files"

bak() {
  src="$1"
  if [ -e "$src" ]; then
    cp "$src" "$DEST/"
    echo "  ✓ $src"
  else
    echo "  ✗ missing (skipped): $src" >&2
  fi
}

bak /etc/NetworkManager/conf.d/20-connectivity.conf
bak /etc/environment
bak /etc/modprobe.d/nobeep.conf
bak /etc/samba/smb.conf
bak /usr/lib/sddm/sddm.conf.d/default.conf
bak /etc/systemd/system/kanata.service
bak /usr/local/bin/bilal
bak /usr/local/bin/confetti
bak /usr/local/bin/hyprland-minimizer
bak /usr/share/albert/widgetsboxmodel/themes/Arc\ Dark.ini
bak /usr/share/albert/widgetsboxmodel/themes/Tokyonight\ Dark.ini
bak /usr/share/sddm/themes/simple-sddm/theme.conf

notify-send -t 3000 "Arch-Backup updated"
