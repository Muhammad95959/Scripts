#!/bin/bash

i3-msg scratchpad show ||
	if [[ $(i3-msg -t get_tree | jq '.. | objects | select(.focused==true) | .floating == "user_off"') == "true" ]]; then
		bash -c "i3-msg floating enable && i3-msg resize set 1280px 720px && i3-msg move position center && i3-msg move scratchpad"
	else
		i3-msg move scratchpad
	fi
