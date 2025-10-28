#!/bin/sh

blue_jeans="#61AFEF"
blue_jeans_companion="#8FC7F4"
deep_champagne="#EED49F"
deep_champagne_companion="#E6C073"
lavender_blue="#CDD6F4"
lavender_blue_companion="#A4B4EA"
light_salmon="#F5A97F"
light_salmon_companion="#F18950"
middle_blue_green="#8BD5CA"
middle_blue_green_companion="#66C7B9"
pale_violet="#C6A0F6"
pale_violet_compaion="#AD73F2"
ruddy_pink="#ED8796"
ruddy_pink_companion="#EA7183"
slate_blue="#7B58DC"
slate_blue_companion="#6A43D8"

chosen=$(printf "\
Blue Jeans
Deep Champagne
Lavender Blue
Light Salmon
Middle Blue Green
Pale Violet
Ruddy Pink
Slate Blue\
" | rofi -dmenu -no-custom -i -theme ~/.config/rofi/border_color_chooser.rasi -p "choose a color: ")

change_border() {
  c1=$(echo "$1" | sed 's/#//')
  c2=$(echo "$2" | sed 's/#//')
  sed -Ei "/col\.active_border/ s/(col\.active_border =).*/\1 rgba(${c1}EE) rgba(${c2}EE) 45deg/" ~/DotFiles/.config/hypr/hyprland.conf
  sed -Ei "/col\.border_active/ s/(col\.border_active =).*/\1 rgba(${c1}EE) rgba(${c2}EE) 45deg/" ~/DotFiles/.config/hypr/hyprland.conf
  sed -Ei "/col\.active/ s/(col\.active =).*/\1 rgba(${c1}EE) rgba(${c2}EE) 45deg/" ~/DotFiles/.config/hypr/hyprland.conf
  sed -Ei "/col\.locked_active/ s/(col\.locked_active\s*=\s*).*/\1rgba(${c2}EE)/" ~/DotFiles/.config/hypr/hyprland.conf
}

case "$chosen" in
"Blue Jeans") change_border "$blue_jeans" "$blue_jeans_companion" ;;
"Deep Champagne") change_border "$deep_champagne" "$deep_champagne_companion" ;;
"Lavender Blue") change_border "$lavender_blue" "$lavender_blue_companion" ;;
"Light Salmon") change_border "$light_salmon" "$light_salmon_companion" ;;
"Middle Blue Green") change_border "$middle_blue_green" "$middle_blue_green_companion" ;;
"Pale Violet") change_border "$pale_violet" "$pale_violet_compaion" ;;
"Ruddy Pink") change_border "$ruddy_pink" "$ruddy_pink_companion" ;;
"Slate Blue") change_border "$slate_blue" "$slate_blue_companion" ;;
esac
