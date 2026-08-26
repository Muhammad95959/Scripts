#!/bin/sh

set -eu

DEST="$HOME/Arch-Setup/root"

bak() {
  src="$1"
  rel="${src#/}"          # strip leading /
  dst="$DEST/$rel"
  if [ -e "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  ✓ $src"
  else
    echo "  ✗ missing (skipped): $src" >&2
  fi
}

bak /etc/NetworkManager/conf.d/20-connectivity.conf
bak /etc/default/grub
bak /etc/environment
bak /etc/greetd/config.toml
bak /etc/greetd/tuigreet.toml
bak /etc/modprobe.d/nobeep.conf
bak /etc/samba/smb.conf
bak /etc/systemd/system/kanata.service
bak /etc/systemd/system/switch-to-tty1-shutdown.service
bak /usr/local/bin/bilal
bak /usr/local/bin/confet
bak /usr/local/bin/hyprland-minimizer
bak /usr/share/albert/widgetsboxmodel/themes/Arc\ Dark.ini
bak /usr/share/albert/widgetsboxmodel/themes/Tokyonight\ Dark.ini
bak /usr/share/wayland-sessions/hyprland-silent.desktop
notify-send -t 3000 "Arch-Backup updated"
