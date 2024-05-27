#!/bin/sh

if [ ! -f /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak ]; then
	cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
  ~/Scripts/update_DotFiles_repo.sh
fi
