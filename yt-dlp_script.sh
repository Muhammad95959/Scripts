#!/bin/sh

cd ~/Downloads || echo "$HOME/Downloads directory doesn't exist"
toilet yt-dlp script -w 100 --metal --filter border

blueText() {
	reset="\033[0m"
	blue="\033[1;34m"
	echo "$blue$1$reset"
}

printf "%s" "$(blueText "Do you want to download a playlist? [n/y]: ")"
read -r isPlaylist

split=""
if [ "$isPlaylist" = "y" ] || [ "$isPlaylist" = "Y" ]; then
	printf "%s" "$(blueText "\n1: download certain videos\n2: download the full playlist (default)\nyour choice : ")"
	read -r pChoice
else
	printf "%s" "$(blueText "\nDo you want to split chapters? [n/y]: ")"
	read -r split
fi

if [ "$split" = "y" ] || [ "$split" = "Y" ]; then
	split="--split-chapters"
fi

printf "%s" "
$(blueText "url: ")"
read -r url

toDownload=""
case $pChoice in
1)
	printf "%s" "$(blueText "\nthe videos in the format [ eg: 1,3-7,13 ] : ")"
	read -r pVideos
	toDownload="--playlist-items=$pVideos"
	;;
*) ;;
esac

printf "%s" "$(blueText "
download options:- 
1: all
2: audio only
3: video only
4: full (default)

your choice : ")"
read -r choice

case $choice in
1) yt-dlp -F "$toDownload" "$url" ;;
2) yt-dlp -F "$toDownload" "$url" | grep -i 'audio only\|^\[download' ;;
3) yt-dlp -F "$toDownload" "$url" | grep -i 'video only\|^\[download' ;;
*) yt-dlp -F "$toDownload" "$url" | sed '/images/d;/audio\ only/d;/video\ only/d;/^\[youtube/d;/^\[info/d' ;;
esac

printf "%s" "$(blueText "\nyour chosen ID : ")"
read -r quality

case $isPlaylist in
y | Y) yt-dlp -f "$quality" -o "%(playlist_index)02d - %(title)s.%(ext)s" "$toDownload" "$url" ;;
*) yt-dlp "$split" -f "$quality" "$url" ;;
esac

notify-send "download completed"
