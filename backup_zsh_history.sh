#!/bin/sh

if [ ! -f /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak ]; then
	cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
  sudo timeshift --create
  ~/Scripts/update_DotFiles_repo.sh
  sudo updatedb &
fi
