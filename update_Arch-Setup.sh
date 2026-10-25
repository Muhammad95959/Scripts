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

bak_arch_conf() {
  src="/boot/loader/entries/arch.conf"
  rel="boot/loader/entries/arch.conf"
  dst="$DEST/$rel"
  if [ -e "$src" ] || [ -L "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    sudo cp -a "$src" "$dst"
    sudo chown "$(id -u):$(id -g)" "$dst"
    sed -i 's/root=UUID=[0-9a-fA-F-]\+/root=UUID=@ROOT_UUID@/' "$dst"
    echo "  ✓ $src (uuid templated)"
  else
    echo "  ✗ missing (skipped): $src" >&2
  fi
}

bak_snapper_boot() {
  src="/usr/local/bin/snapper-systemd-boot.sh"
  rel="usr/local/bin/snapper-systemd-boot.sh"
  dst="$DEST/$rel"
  if [ -e "$src" ] || [ -L "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    sudo cp -a "$src" "$dst"
    sudo chown "$(id -u):$(id -g)" "$dst"
    python3 - "$dst" <<'PY'
import re, sys
p = sys.argv[1]
s = open(p).read()
m = re.search(r'^ROOT_UUID="([^"]*)"$', s, re.M)
uuid = m.group(1) if m else ""
new = (
    '# Auto-detect root UUID at runtime so a fresh install with a new disk works.\n'
    '# Fallback is the previous machine\'s UUID (kept for reference only).\n'
    'ROOT_UUID="$(findmnt -no UUID / 2>/dev/null || true)"\n'
    'if [[ -z "$ROOT_UUID" ]]; then\n'
    '  ROOT_UUID="%s"\n'
    'fi' % uuid
)
s = re.sub(r'^ROOT_UUID="[^"]*"$', new, s, flags=re.M, count=1)
open(p, "w").write(s)
PY
    echo "  ✓ $src (uuid auto-detected)"
  else
    echo "  ✗ missing (skipped): $src" >&2
  fi
}

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
bak /etc/systemd/system/snapper-systemd-boot.path
bak /etc/systemd/system/snapper-systemd-boot.service
bak /etc/systemd/system/start-services.service
bak /etc/systemd/system/switch-to-tty1-shutdown.service
bak /usr/local/bin/bilal
bak /usr/local/bin/confet
bak /usr/local/bin/hyprland-minimizer
bak /usr/share/wayland-sessions/hyprland-silent.desktop

bak_arch_conf
bak_snapper_boot

notify-send -t 3000 "Arch-Backup updated"
