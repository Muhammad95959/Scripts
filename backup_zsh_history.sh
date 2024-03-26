#!/bin/bash

[[ ! -f /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_$(date +%Y-%m-%d).bak ]] && cp /home/muhammad/.zhistory /mnt/Disk_D/Muhammad/Linux_stuff/Backup/zsh_history/zsh_history_"$(date +%Y-%m-%d)".bak
