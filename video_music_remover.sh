#!/bin/sh
audio_separator="/mnt/Disk_D/برامج/Linux/python312/bin/audio-separator"
model_dir="/mnt/Disk_D/Muhammad/Audio-Separator-Models"
model_name="1_HP-UVR.pth"
[ -z "$1" ] && exit 1
for input_video in "$@"; do
  parts_dir="${input_video}-parts"
  output_file="${input_video}-music-free.mp4"
  [ -f "$output_file" ] && continue

  # Get duration and calculate part count to determine padding width
  duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$input_video" | cut -d. -f1)
  [ -z "$duration" ] && {
    echo "ERROR: could not read duration of $input_video"
    exit 1
  }
  part_count=$(((duration + 179) / 180))
  pad=${#part_count}

  [ -d "$parts_dir" ] || { mkdir "$parts_dir" && ffmpeg -i "$input_video" -c copy -segment_time 180 -f segment "$parts_dir/part%0${pad}d.mp4"; }
  cd "$parts_dir" || exit 1
  count=$(find . -maxdepth 1 -type f -name 'part*.mp4' | wc -l)
  true >output_list.txt
  i=0
  while [ "$i" -lt "$count" ]; do
    num=$(printf "%0${pad}d" "$i")
    video="part${num}.mp4"
    audio="part${num}_(Vocals)_1_HP-UVR.mp3"
    output="output_part${num}.mp4"
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
  ffmpeg -f concat -safe 0 -i output_list.txt -c copy "../$output_file" ||
    {
      echo "ERROR: final concat failed"
      exit 1
    }
  cd .. || exit 1
done
