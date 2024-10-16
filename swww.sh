#!/bin/zsh

# Array of all wallpapers
wallpapers=(/mnt/Disk_D/Backgrounds/*.jpg)

# Getting the current wallpaper with `swww query`
current_wallpaper_path=$(swww query | sed -n 's/.*image: \(.*\)/\1/p')

# Check if the daemon is running, start it if not
if ! pgrep -x "swww-daemon" > /dev/null; then
  swww-daemon &!
  sleep 1  # give it a moment to start
fi

# Extract current wallpaper filename
current_wallpaper_name=${current_wallpaper_path:t}

# Show menu (with icon)
selected_wallpaper=$(
  for a in $wallpapers; do
    if [[ ${a:t} == $current_wallpaper_name ]]; then
      echo -en "${a:t} (current)\0icon\x1f$a\n"
    else
      echo -en "${a:t}\0icon\x1f$a\n"
    fi
  done | rofi -dmenu -p " " -theme ~/.config/rofi/swww.rasi
)

# Removing " (current)" from the selected wallpaper
final_wallpaper=$(echo $selected_wallpaper | sed "s/ (current)//")

# If a valid wallpaper was selected, change wallpaper and colorscheme
if [[ -n "$final_wallpaper" ]]; then
  swww img "/mnt/Disk_D/Backgrounds/$final_wallpaper" --transition-type fade --transition-fps 60 --transition-step 100
  ln -sf "/mnt/Disk_D/Backgrounds/$final_wallpaper" ~/.cache/current-wallpaper && # creates a symlink to the current wallpaper
fi
