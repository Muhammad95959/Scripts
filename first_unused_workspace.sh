#!/bin/sh

# Get the workspaces in use in i3
used_workspaces=$(i3-msg -t get_workspaces | jq '.[] | .num')

# Create a list of all possible workspace numbers from 1 to 10
all_workspaces=$(seq 1 10)

# Find the first unused workspace
first_unused_workspace=""
for i in $all_workspaces; do
	if ! echo "$used_workspaces" | grep -q "$i"; then
		first_unused_workspace=$i
		break
	fi
done

echo "$first_unused_workspace"
