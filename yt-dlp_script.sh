#!/bin/sh

# Trap SIGINT (Ctrl+C) to print a message instead of killing the script
trap 'printf "\n[Skipping to next step...]\n"' INT

# Exit if Downloads dir is missing
cd ~/Downloads || {
  echo "Error: ~/Downloads does not exist"
  exit 1
}

# Show banner only if toilet is available
command -v toilet >/dev/null 2>&1 &&
  toilet "yt-dlp script" -w 100 --metal --filter border

# --- Helper: print in blue ---
blue() { printf "\033[1;34m%b\033[0m" "$1"; }

# --- Playlist or single video? ---
blue "Do you want to download a playlist? [n/y]: "
read -r isPlaylist

splitFlag=""
toDownload=""
pChoice=""

if [ "$isPlaylist" = "y" ] || [ "$isPlaylist" = "Y" ]; then
  blue "\n1: download certain videos\n2: download the full playlist (default)\nyour choice : "
  read -r pChoice
else
  blue "\nDo you want to split chapters? [n/y]: "
  read -r splitChoice
  [ "$splitChoice" = "y" ] || [ "$splitChoice" = "Y" ] && splitFlag="--split-chapters"
fi

# --- URL ---
blue "\nurl: "
read -r url
[ -z "$url" ] && {
  echo "Error: URL cannot be empty."
  exit 1
}

# --- Playlist item selection ---
if [ "$pChoice" = "1" ]; then
  blue "\nVideos to download [eg: 1,3-7,13]: "
  read -r pVideos
  toDownload="--playlist-items=$pVideos"
fi

# --- Format selection ---
yt-dlp -F ${toDownload:+"$toDownload"} "$url"

blue "your chosen ID : "
read -r quality
[ -z "$quality" ] && {
  echo "Error: format ID cannot be empty."
  exit 1
}

# --- Download ---
case $isPlaylist in
y | Y) yt-dlp -f "$quality" -o "%(playlist_index)02d - %(title)s.%(ext)s" ${toDownload:+"$toDownload"} "$url" ;;
*) yt-dlp ${splitFlag:+"$splitFlag"} -f "$quality" "$url" ;;
esac

# Notify if available
command -v notify-send >/dev/null 2>&1 && notify-send "download completed"
blue "Done!\n"
