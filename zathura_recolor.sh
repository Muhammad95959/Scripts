chosen=$(printf "\
Mustard on Deep Charcoal 'B'
Mustard on Deep Charcoal
Canary Yellow on Black
White on Black
Black on White
Black on Beige
catppuccin 'B'
catppuccin
embark\
" | rofi -dmenu -i -theme ~/.config/rofi/zathura_recolor.rasi -p "choose a theme: ")

case "$chosen" in
  "Mustard on Deep Charcoal 'B'")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#ffdb58\"\n\
set statusbar-bg       \"#000000\"\n\
set recolor-darkcolor  \"#ffdb58\"\n\
set recolor-lightcolor \"#111111\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"Mustard on Deep Charcoal")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#111111\"\n\
set statusbar-bg       \"#000000\"\n\
set recolor-darkcolor  \"#ffdb58\"\n\
set recolor-lightcolor \"#111111\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"Canary Yellow on Black")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#000000\"\n\
set statusbar-bg       \"#141414\"\n\
set recolor-darkcolor  \"#ffee00\"\n\
set recolor-lightcolor \"#000000\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"White on Black")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#000000\"\n\
set statusbar-bg       \"#141414\"\n\
set recolor-darkcolor  \"#ffffff\"\n\
set recolor-lightcolor \"#000000\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"Black on White")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#ffffff\"\n\
set statusbar-bg       \"#141414\"\n\
set recolor-darkcolor  \"#000000\"\n\
set recolor-lightcolor \"#ffffff\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"Black on Beige")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg         \"#000000\"\n\
set statusbar-bg       \"#141414\"\n\
set recolor-darkcolor  \"#000000\"\n\
set recolor-lightcolor \"#ffe1ba\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"catppuccin 'B'")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg               \"#CDD6F4\"\n\
set statusbar-bg             \"#313244\"\n\
set recolor-lightcolor       \"#1E1E2E\"\n\
set recolor-darkcolor        \"#CDD6F4\"\n\
set default-fg               \"#CDD6F4\"\n\
set completion-bg            \"#313244\"\n\
set completion-fg            \"#CDD6F4\"\n\
set completion-highlight-bg  \"#575268\"\n\
set completion-highlight-fg  \"#CDD6F4\"\n\
set completion-group-bg      \"#313244\"\n\
set completion-group-fg      \"#89B4FA\"\n\
set statusbar-fg             \"#CDD6F4\"\n\
set notification-bg          \"#313244\"\n\
set notification-fg          \"#CDD6F4\"\n\
set notification-error-bg    \"#313244\"\n\
set notification-error-fg    \"#F38BA8\"\n\
set notification-warning-bg  \"#313244\"\n\
set notification-warning-fg  \"#FAE3B0\"\n\
set inputbar-fg              \"#CDD6F4\"\n\
set inputbar-bg              \"#313244\"\n\
set index-fg                 \"#CDD6F4\"\n\
set index-bg                 \"#1E1E2E\"\n\
set index-active-fg          \"#CDD6F4\"\n\
set index-active-bg          \"#313244\"\n\
set render-loading-bg        \"#1E1E2E\"\n\
set render-loading-fg        \"#CDD6F4\"\n\
set highlight-color          \"#575268\"\n\
set highlight-fg             \"#F5C2E7\"\n\
set highlight-active-color   \"#F5C2E7\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"catppuccin")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg               \"#1E1E2E\"\n\
set statusbar-bg             \"#313244\"\n\
set recolor-lightcolor       \"#1E1E2E\"\n\
set recolor-darkcolor        \"#CDD6F4\"\n\
set default-fg               \"#CDD6F4\"\n\
set completion-bg            \"#313244\"\n\
set completion-fg            \"#CDD6F4\"\n\
set completion-highlight-bg  \"#575268\"\n\
set completion-highlight-fg  \"#CDD6F4\"\n\
set completion-group-bg      \"#313244\"\n\
set completion-group-fg      \"#89B4FA\"\n\
set statusbar-fg             \"#CDD6F4\"\n\
set notification-bg          \"#313244\"\n\
set notification-fg          \"#CDD6F4\"\n\
set notification-error-bg    \"#313244\"\n\
set notification-error-fg    \"#F38BA8\"\n\
set notification-warning-bg  \"#313244\"\n\
set notification-warning-fg  \"#FAE3B0\"\n\
set inputbar-fg              \"#CDD6F4\"\n\
set inputbar-bg              \"#313244\"\n\
set index-fg                 \"#CDD6F4\"\n\
set index-bg                 \"#1E1E2E\"\n\
set index-active-fg          \"#CDD6F4\"\n\
set index-active-bg          \"#313244\"\n\
set render-loading-bg        \"#1E1E2E\"\n\
set render-loading-fg        \"#CDD6F4\"\n\
set highlight-color          \"#575268\"\n\
set highlight-fg             \"#F5C2E7\"\n\
set highlight-active-color   \"#F5C2E7\"\n" "$HOME"/.config/zathura/zathurarc
	;;
"embark")
	sed -i "1,/^$/\
c\-- Recoloring\n\
set default-bg              \"#1E1C31\"\n\
set statusbar-bg            \"#1E1C31\"\n\
set recolor-darkcolor       \"#CBE3E7\"\n\
set recolor-lightcolor      \"#1E1C31\"\n\
set notification-error-bg   \"#1E1C31\"\n\
set notification-error-fg   \"#F48FB1\"\n\
set notification-warning-bg \"#1E1c31\"\n\
set notification-warning-fg \"#FFE6B3\"\n\
set notification-bg         \"#1E1C31\"\n\
set notification-fg         \"#CBE3E7\"\n\
set completion-bg           \"#1E1C31\"\n\
set completion-fg           \"#CBE3E7\"\n\
set completion-group-bg     \"#A1EFD3\"\n\
set completion-group-fg     \"#2D2B40\"\n\
set completion-highlight-bg \"#FFE6B3\"\n\
set completion-highlight-fg \"#2D2B40\"\n\
set index-bg                \"#1E1C31\"\n\
set index-fg                \"#CBE3E7\"\n\
set index-active-bg         \"#CBE3E7\"\n\
set index-active-fg         \"#1E1C31\"\n\
set inputbar-bg             \"#1E1C31\"\n\
set inputbar-fg             \"#CBE3E7\"\n\
set statusbar-fg            \"#CBE3E7\"\n\
set highlight-color         \"#F48FB1\"\n\
set highlight-active-color  \"#87DFEB\"\n\
set default-fg              \"#CBE3E7\"\n\
set render-loading-bg       \"#3E3859\"\n\
set render-loading-fg       \"#CBE3E7\"\n" "$HOME"/.config/zathura/zathurarc
	;;
esac

if [ -z "$chosen" ]
then
  exit 1
fi

if [ "$(xdotool getactivewindow getwindowclassname)" == "Zathura" ]; then
  xdotool type ":"
  xdotool type "s"
  xdotool type "o"
  xdotool type "u"
  xdotool type "r"
  xdotool type "c"
  xdotool type "e"
  xdotool key Return
  xdotool key Escape
fi
