#!/bin/sh

if [ "$1" = "-a" ]; then
  curl -s 'http://di107.dar-alifta.org/api/HijriDate?langID=1' | iconv -f UTF-16 -t UTF-8 | sed 's/"//' | sed 's/"/\r/' 2>/dev/null
  bilal all | sed -E 's/Sherook/Shuruk/; s/Dohr/Dhuhr/; s/Ma?ghreb/Maghrib/'
elif [ "$1" = "-r" ]; then
  next_salah=$(bilal next | awk '{print $1}')
  time_value=$(bilal current | awk -F '(' '{print $2}' | awk 'BEGIN{OFS=" ";} {print $1}')
  time_scale=$(bilal current | awk -F '(' '{print $2}' | awk 'BEGIN{OFS=" ";} {print $2}')
  if [ "$time_scale" = "hours" ]; then
    hours=$(printf "%s" "$time_value" | awk -F ':' '{print $1}')
    minutes=$(printf "%s" "$time_value" | awk -F ':' '{print $2}')
    if [ "$minutes" = "60" ]; then
      minutes="00"
      hours=$((hours + 1))
    fi
    [ "$(printf "%s" "$hours" | wc -c)" -lt 2 ] && hours="0$hours"
    [ "$(printf "%s" "$minutes" | wc -c)" -lt 2 ] && minutes="0$minutes"
    time_value="$hours:$minutes"
  elif [ "$time_scale" = "minutes" ]; then
    if [ "$time_value" = "60" ]; then
      time_value="01:00"
    else
      [ "$(printf "%s" "$time_value" | wc -c)" -lt 2 ] && time_value="0$time_value"
      time_value="00:$time_value"
    fi
  fi
  current_time_in_minutes="$(($(date +"%H" | sed -E 's/^0?//') * 60 + $(date +"%M" | sed -E 's/^0?//')))"
  previous_salah_name=$(bilal current | awk '{print $1}' | sed 's/Maghreb/Mghreb/')
  previous_salah_time=$(bilal all | awk -v p="$previous_salah_name" -F ': ' '{if (p == "Jumua") p = "Dohr"} $1 == p {print $2}')
  previous_salah_time_in_minutes="$((\
    $(echo "$previous_salah_time" | sed -E 's/:.*$//; s/^0?//') * 60 + \
    $(echo "$previous_salah_time" | awk -F ':' '{print $2}' | sed -E 's/^0?//')))"
  time_passed_since_previous_salah="$((current_time_in_minutes - previous_salah_time_in_minutes))"
  if [ "$time_passed_since_previous_salah" -le 30 ] && [ "$time_passed_since_previous_salah" -ge 0 ]; then
    echo "$time_passed_since_previous_salah min after $previous_salah_name" | sed -E 's/Sherook/Shuruk/; s/Dohr/Dhuhr/; s/Ma?ghreb/Maghrib/'
  else
    echo "$time_value until $next_salah" | sed -E 's/Sherook/Shuruk/; s/Dohr/Dhuhr/; s/Ma?ghreb/Maghrib/'
  fi
fi
