#!/bin/sh

set -eu

DEST="$HOME/Arch-Setup/root"

bak() {
  src="$1"
  rel="${src#/}"          # strip leading /
  dst="$DEST/$rel"
  if [ -e "$src" ] || [ -L "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    sudo cp -a "$src" "$dst"
    sudo chown "$(id -u):$(id -g)" "$dst"
    echo "  ✓ $src"
  else
    echo "  ✗ missing (skipped): $src" >&2
  fi
}

bak /boot/loader/entries/arch.conf
bak /boot/loader/loader.conf
bak /etc/NetworkManager/conf.d/20-connectivity.conf
bak /etc/booster.yaml
bak /etc/environment
bak /etc/greetd/config.toml
bak /etc/greetd/tuigreet.toml
bak /etc/modprobe.d/nobeep.conf
bak /etc/pacman.d/hooks/99-snapper-systemd-boot.hook
bak /etc/samba/smb.conf
bak /etc/snapper/configs/root
bak /etc/sysctl.d/99-sysctl.conf
bak /etc/systemd/system/kanata.service
bak /etc/systemd/system/libvirtd-delay.timer
bak /etc/systemd/system/libvirtd.service.d/10-secret.conf
bak /etc/systemd/system/nmb-delay.timer
bak /etc/systemd/system/snapper-systemd-boot.path
bak /etc/systemd/system/snapper-systemd-boot.service
bak /etc/systemd/system/switch-to-tty1-shutdown.service
bak /etc/systemd/system/upower.service.d/no-block.conf
bak /usr/local/bin/bilal
bak /usr/local/bin/confet
bak /usr/local/bin/hyprland-minimizer
bak /usr/local/bin/snapper-systemd-boot.sh
bak /usr/share/albert/widgetsboxmodel/themes/Arc\ Dark.ini
bak /usr/share/albert/widgetsboxmodel/themes/Tokyonight\ Dark.ini
bak /usr/share/wayland-sessions/hyprland-silent.desktop
notify-send -t 3000 "Arch-Backup updated"
