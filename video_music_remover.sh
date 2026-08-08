#!/bin/sh
audio_separator="audio-separator"
model_dir="$HOME/.local/share/pipx/venvs/audio-separator/models"
model_name="1_HP-UVR.pth"

[ -z "$1" ] && exit 1
for input_video in "$@"; do
  base="${input_video%.*}"
  ext="${input_video##*.}"
  backup_video="${base}.original.${ext}"
  parts_dir="${base}-parts"
  output_file="$input_video"

  # Already fully processed -> skip
  [ -f "$backup_video" ] && continue

  # Get duration and calculate part count to determine padding width
  duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$input_video" | cut -d. -f1)
  [ -z "$duration" ] && {
    echo "ERROR: could not read duration of $input_video"
    exit 1
  }
  part_count=$(((duration + 179) / 180))
  pad=${#part_count}
  [ -d "$parts_dir" ] || { mkdir "$parts_dir" && ffmpeg -i "$input_video" -c copy -segment_time 180 -segment_start_number 1 -f segment "$parts_dir/part%0${pad}d.${ext}"; }
  cd "$parts_dir" || exit 1
  count=$(find . -maxdepth 1 -type f -name "part*.${ext}" | wc -l)
  true >output_list.txt
  i=1
  while [ "$i" -le "$count" ]; do
    num=$(printf "%0${pad}d" "$i")
    video="part${num}.${ext}"
    audio="part${num}_(Vocals)_1_HP-UVR.mp3"
    output="output_part${num}.${ext}"
    if [ ! -f "$output" ]; then
      "$audio_separator" --model_file_dir "$model_dir" --model_filename "$model_name" \
        --single_stem Vocals --output_format=MP3 "$video" ||
        {
          echo "ERROR: audio-separator failed on $video"
          exit 1
        }
      ffmpeg -i "$video" -i "$audio" -map 0:v -map 1:a -c:v copy -c:a aac "$output" ||
        {
          echo "ERROR: ffmpeg failed on $video"
          exit 1
        }
    fi
    echo "file '$output'" >>output_list.txt
    i=$((i + 1))
  done
  cd .. || exit 1

  # Rename the original only now, right before producing the final combined file
  mv "$input_video" "$backup_video" || {
    echo "ERROR: could not rename $input_video to $backup_video"
    exit 1
  }

  ffmpeg -f concat -safe 0 -i "$parts_dir/output_list.txt" -c copy "$output_file" ||
    {
      echo "ERROR: final concat failed"
      exit 1
    }
done
