#!/bin/bash

input_video=$1
audio_separator="/mnt/Disk_D/برامج/Linux/python312/bin/audio-separator"
model_dir="/mnt/Disk_D/Muhammad/Audio-Separator-Models"
model_name="1_HP-UVR.pth"

[ -z "$input_video" ] && exit 1
[ -f "$input_video"-music-free.mp4 ] && exit 0

mkdir "$input_video"-parts && ffmpeg -i "$input_video" -c copy -segment_time 180 -f segment "$input_video"-parts/part%d.mp4

cd "$input_video"-parts || exit 1

count=$(find . -maxdepth 1 -type f -name 'part*.mp4' | wc -l)

for ((i = 0; i < count; i++)); do
  video="part${i}.mp4"
  audio="part${i}_(Vocals)_1_HP-UVR.mp3"
  output="output_part${i}.mp4"
  [ -f "$output" ] && continue
  $audio_separator --model_file_dir "$model_dir" --model_filename "$model_name" --single_stem Vocals --output_format=MP3 "$video"
  ffmpeg -i "$video" -i "$audio" -map 0:v -map 1:a -c:v copy -c:a aac "$output"
  echo "file '$output'" >>output_list.txt
done

[ -f ../"$input_video"-music-free.mp4 ] && exit

ffmpeg -f concat -safe 0 -i output_list.txt -c copy ../"$input_video"-music-free.mp4

cd .. || exit 1
