#!/bin/sh

MAX_URL_LEN=55
url=$(wl-paste)

short_url=$(echo "$url" | cut -c1-$MAX_URL_LEN)
[ ${#url} -gt $MAX_URL_LEN ] && short_url="${short_url}…"

quality=$(printf "144p\n240p\n360p\n480p\n720p\n1080p" | rofi -dmenu -mesg "$short_url" -theme ~/.config/rofi/url_to_mpv.rasi)

[ -z "$quality" ] && exit 1

height=${quality%p}
mpv --ytdl-format="bestvideo[height<=$height]+bestaudio/best[height<=$height]" "$url"
