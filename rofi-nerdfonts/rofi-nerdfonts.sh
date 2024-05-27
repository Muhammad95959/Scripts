#!/bin/bash

# if argument is passed, use it as csv, otherwise, look for file relative to dir
if [ $# -eq 0 ]; then
    # get location of chars.csv relative to script
    chars_csv="$(dirname "$0")/chars.csv"
else
    chars_csv="$1"
fi
# if csv file does not exist, error and exit
[ ! -f "${chars_csv}" ] && { echo "${chars_csv} is not a valid file" >&2; exit 1; }

# read in lines from code.csv into array
readarray chars < "${chars_csv}"

# print all codes and names (replacing command with space) and select using rofi
char_entry=$(
    for char in "${chars[@]}";{
        printf "%s" "${char/,/ }"
    }|rofi -dmenu -theme ~/.config/rofi/emoji_dropdown.rasi -p "Search:"
)

# If user cancelled rofi, exit
[ -z "${char_entry}" ] && exit

# get char from line
char="${char_entry% *}"
# get codepoint from char (needed for xdotool)
codepoint=U$(printf %x\\n \'"${char}")
# copy the char to clipboard
echo "${char_entry}" | awk '{printf "%s", $1}' | xclip -selection clipboard
# use xdotool to enter character
xdotool key "${codepoint}"
