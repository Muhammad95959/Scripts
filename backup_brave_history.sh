#!/bin/sh

SRC="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
DST="/mnt/Disk_D/Muhammad/Linux-Backup/BraveHistoryArchive.db"
SRC_ALt="/tmp/BraveHistory"

if [ ! -f "$DST" ]; then
  sqlite3 "$DST" <<EOF
  CREATE TABLE IF NOT EXISTS urls (
    id INTEGER PRIMARY KEY,
    url TEXT UNIQUE,
    title TEXT,
    last_visit_time INTEGER
  );
EOF
fi

if pgrep -x brave >/dev/null; then
  if [ -f "$SRC_ALt" ]; then
    SRC="$SRC_ALt"
  else
    echo "Please close Brave before running $0"
    notify-send "Please close Brave before running $0"
    exit 1
  fi
fi

sqlite3 "$DST" <<EOF
ATTACH DATABASE '$SRC' AS live;
INSERT OR IGNORE INTO urls (url, title, last_visit_time)
SELECT url, title, last_visit_time FROM live.urls;
EOF
