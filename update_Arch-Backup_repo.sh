#!/bin/sh

cp  -r /usr/share/pixmaps/volnoti                              /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /etc/NetworkManager/conf.d/20-connectivity.conf            /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /usr/share/albert/widgetsboxmodel-ng/themes/Arc\ Dark.ini  /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /etc/environment                                           /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /etc/modprobe.d/nobeep.conf                                /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /etc/samba/smb.conf                                        /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/
cp  /usr/lib/systemd/system/kanata.service                     /mnt/Disk_D/Muhammad/Repositories/Arch-Backup/root_files/

notify-send -t 3000 "updated Arch-Backup repo"
