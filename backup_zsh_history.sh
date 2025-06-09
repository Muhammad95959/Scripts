#!/bin/sh

if [ ! -f /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak ]; then
	cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
	cp /home/muhammad/.cache/greenclip.history /mnt/Disk_D/Muhammad/Linux_stuff/Backup/greenclip_history/greenclip_history_"$(date +%Y-%m-%d)".bak
  sudo timeshift --create
  ~/Scripts/update_Arch-Backup_repo.sh
  sudo updatedb &
fi
