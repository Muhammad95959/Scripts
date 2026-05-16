#!/bin/sh

if [ ! -f /mnt/Disk_D/Muhammad/Linux-Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak ]; then
  cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux-Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
  cp /home/muhammad/.local/share/greenclip.history /mnt/Disk_D/Muhammad/Linux-Backup/greenclip_history/greenclip_history_"$(date +%Y-%m-%d)".bak
  sudo timeshift --create
  ~/Scripts/update_Arch-Backup_repo.sh
  mkdir -p ~/.cache/aur && curl -s https://aur.archlinux.org/packages.gz | gzip -d >~/.cache/aur/packages.txt &
  sudo updatedb &
fi
