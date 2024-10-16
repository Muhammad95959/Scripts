#!/bin/sh

gaps_out=$(hyprctl -j getoption general:gaps_out | jq '.custom' | awk '{print $2}')

case $1 in
  --inc) hyprctl --batch "keyword general:gaps_in $(((gaps_out + 10) / 2)); keyword general:gaps_out $((gaps_out + 10))" ;;
  --dec) hyprctl --batch "keyword general:gaps_in $(((gaps_out - 10) / 2)); keyword general:gaps_out $((gaps_out - 10))" ;;
esac
