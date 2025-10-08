#!/bin/sh

if [ ! -f /mnt/Disk_D/Muhammad/Linux-Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak ]; then
	cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux-Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
	cp /home/muhammad/.local/share/greenclip.history /mnt/Disk_D/Muhammad/Linux-Backup/greenclip_history/greenclip_history_"$(date +%Y-%m-%d)".bak
  sudo timeshift --create
  ~/Scripts/backup_brave_history.sh
  ~/Scripts/update_Arch-Backup_repo.sh
  sudo updatedb &
fi
