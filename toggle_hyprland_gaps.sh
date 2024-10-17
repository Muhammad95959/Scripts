#!/bin/sh

gaps_out=$(hyprctl -j getoption general:gaps_out | jq '.custom' | awk '{print $2}')

if [ "$gaps_out" -gt 10 ] || [ "$gaps_out" -eq 0 ];then
  hyprctl --batch "keyword general:gaps_in 5; keyword general:gaps_out 10"
else
  hyprctl --batch "keyword general:gaps_in 0; keyword general:gaps_out 0"
fi
