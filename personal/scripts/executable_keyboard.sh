#!/bin/bash

# Get all keyboard identifiers
keyboards=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .identifier')

# Get the current layout name
current_layout=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' | head -n 1)

# Debugging: Print current layout
echo "Detected layout: $current_layout"

# Determine the new layout
if [[ "$current_layout" =~ "English" ]]; then
    new_layout="es"
else
    new_layout="us"
fi

# Apply the new layout to all keyboards
for keyboard in $keyboards; do
    swaymsg input "$keyboard" xkb_layout "$new_layout"
done

echo "Switched to $new_layout"
