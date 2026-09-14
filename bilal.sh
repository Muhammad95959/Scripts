#!/bin/sh
# bilal.sh — prayer-time helpers for the Quickshell bar.
#   -a  full details (Hijri date + all times), used for the click notification
#   -r  one-line relative status ("00:15 until Maghrib" / "5 min after Asr")

# Display-name mapping, applied in one place before printing.
normalize() {
  sed -E -e 's/Sherook/Shuruk/g' -e 's/Dohr/Dhuhr/g' -e 's/Ma?ghreb/Maghrib/g'
}

# Map bilal current/next spellings to bilal-all spellings for lookup.
to_all_spelling() {
  case "$1" in
    Maghreb) printf 'Mghreb' ;;
    Jumua) printf 'Dohr' ;;
    *) printf '%s' "$1" ;;
  esac
}

# Zero-pad to 2 digits; safe on empty/non-numeric (falls back to 00).
pad2() {
  case "$1" in
    '' | *[!0-9]*) printf '00' ;;
    *) printf '%02d' "$1" 2>/dev/null || printf '00' ;;
  esac
}

# Strip to digits and leading zeros for arithmetic; empty becomes 0.
to_num() {
  _n=$(printf '%s' "$1" | tr -cd '0-9')
  _n=$(printf '%s' "$_n" | sed 's/^0*//')
  [ -z "$_n" ] && _n=0
  printf '%s' "$_n"
}

if [ "$1" = "-a" ]; then
  hijri=$(curl -sS -m 8 'https://www.dar-alifta.org/ar/services/details/12/التاريخ-الهجري' 2>/dev/null | pup '.date text{}' 2>/dev/null | sed 's/^ *//; s/ *$//')
  [ -n "$hijri" ] && printf '%s\n' "$hijri"
  bilal all 2>/dev/null | normalize
elif [ "$1" = "-r" ]; then
  # Single snapshot: one call each, so value/scale/name can't mix minutes.
  current=$(bilal current 2>/dev/null)
  next_output=$(bilal next 2>/dev/null)
  [ -n "$current" ] && [ -n "$next_output" ] || exit 1

  next_salah=$(printf '%s' "$next_output" | awk '{print $1}')
  inner=$(printf '%s' "$current" | awk -F '[()]' '{print $2}')
  time_value=$(printf '%s' "$inner" | awk '{print $1}')
  time_scale=$(printf '%s' "$inner" | awk '{print $2}')
  previous_salah_name=$(printf '%s' "$current" | awk '{print $1}')

  case "$time_scale" in
    hours)
      hours=${time_value%%:*}
      minutes=${time_value##*:}
      case "$hours$minutes" in
        *[!0-9]* | '') hours=""; minutes="" ;;
      esac
      if [ "$minutes" = "60" ]; then
        minutes="00"
        hours=$(to_num "$hours")
        hours=$((hours + 1))
      fi
      time_value="$(pad2 "$hours"):$(pad2 "$minutes")"
      ;;
    minutes)
      if [ "$time_value" = "60" ]; then
        time_value="01:00"
      else
        time_value="00:$(pad2 "$time_value")"
      fi
      ;;
  esac

  lookup_name=$(to_all_spelling "$previous_salah_name")
  previous_salah_time=$(bilal all 2>/dev/null | awk -v p="$lookup_name" -F ': ' '$1 == p {print $2; exit}')
  if [ -n "$previous_salah_time" ]; then
    h_now=$(to_num "$(date +'%H')")
    m_now=$(to_num "$(date +'%M')")
    ph=$(to_num "${previous_salah_time%%:*}")
    pm=$(to_num "${previous_salah_time##*:}")
    diff=$((h_now * 60 + m_now - (ph * 60 + pm)))
    if [ "$diff" -le 30 ] && [ "$diff" -ge 0 ]; then
      printf '%s min after %s\n' "$diff" "$previous_salah_name" | normalize
      exit 0
    fi
  fi
  printf '%s until %s\n' "$time_value" "$next_salah" | normalize
else
  echo "Usage: $0 [-a|-r]"
fi
