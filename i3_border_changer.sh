#!/bin/sh

light="#ffffff"
dark="#24273a"
blue_jeans="#61afef"
blue_jeans_companion="#8fc7f4"
deep_champagne="#eed49f"
deep_champagne_companion="#e6c073"
lavender_blue="#cdd6f4"
lavender_blue_companion="#a4b4ea"
light_salmon="#f5a97f"
light_salmon_companion="#f18950"
middle_blue_green="#8bd5ca"
middle_blue_green_companion="#66c7b9"
pale_violet="#c6a0f6"
pale_violet_compaion="#ad73f2"
ruddy_pink="#ed8796"
ruddy_pink_companion="#ea7183"
slate_blue="#7b58dc"
slate_blue_companion="#6a43d8"

chosen=$(printf '%s\n' "Blue Jeans" "Deep Champagne" "Lavender Blue" "Light Salmon" "Middle Blue Green" "Pale Violet" "Ruddy Pink" "Slate Blue" |
  rofi -dmenu -no-custom -i -theme ~/.config/rofi/border_color_chooser.rasi -p "choose a color: ")

change_border() {
  sed -Ei "/^client.focused.*###/s/^.*###/client.focused          $1 $1 $3 $2   $1    ###/" ~/DotFiles/.config/i3/config
  i3-msg restart
}

case "$chosen" in
"Blue Jeans") change_border "$blue_jeans" "$blue_jeans_companion" "$dark" ;;
"Deep Champagne") change_border "$deep_champagne" "$deep_champagne_companion" "$dark" ;;
"Lavender Blue") change_border "$lavender_blue" "$lavender_blue_companion" "$dark" ;;
"Light Salmon") change_border "$light_salmon" "$light_salmon_companion" "$dark" ;;
"Middle Blue Green") change_border "$middle_blue_green" "$middle_blue_green_companion" "$dark" ;;
"Pale Violet") change_border "$pale_violet" "$pale_violet_compaion" "$dark" ;;
"Ruddy Pink") change_border "$ruddy_pink" "$ruddy_pink_companion" "$dark" ;;
"Slate Blue") change_border "$slate_blue" "$slate_blue_companion" "$light" ;;
esac
