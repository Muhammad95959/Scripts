#!/bin/sh

DATE=$(date +%Y-%m-%d)

APPS_DIR=/mnt/Disk_D/Muhammad/Linux-Backup/applications
ZSH_DIR=/mnt/Disk_D/Muhammad/Linux-Backup/zsh_history
CLIPHIST_DIR=/mnt/Disk_D/Muhammad/Linux-Backup/cliphist_db

if [ ! -f "${ZSH_DIR}/zsh_history_${DATE}.bak" ]; then
  mkdir -p "${APPS_DIR}" "${ZSH_DIR}" "${CLIPHIST_DIR}"

  cp /home/muhammad/.zhistory "${ZSH_DIR}/zsh_history_${DATE}.bak"
  cp /home/muhammad/.local/share/cliphist/db "${CLIPHIST_DIR}/cliphist_db_${DATE}.bak"
  cp -r /home/muhammad/.local/share/applications/ "${APPS_DIR}/applications_${DATE}.bak"

  # keep only the 5 most recent backups (today's + last 4)
  find "${APPS_DIR}" -maxdepth 1 -name 'applications_*.bak' | sort -r | tail -n +6 | xargs -r rm -r --
  find "${ZSH_DIR}" -maxdepth 1 -name 'zsh_history_*.bak' | sort -r | tail -n +6 | xargs -r rm --
  find "${CLIPHIST_DIR}" -maxdepth 1 -name 'cliphist_db_*.bak' | sort -r | tail -n +6 | xargs -r rm --

  sudo snapper create
  ~/Scripts/update_Arch-Setup.sh
  mkdir -p ~/.cache/aur && curl -s https://aur.archlinux.org/packages.gz | gzip -d >~/.cache/aur/packages.txt &
  sudo updatedb &
fi
