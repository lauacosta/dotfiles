#!/bin/bash

# Get all keyboard identifiers
keyboards=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .identifier')

# Get the current layout of the first keyboard (assuming all have the same layout)
current_layout=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' | head -n 1)

# Log the current layout for debugging
echo "Current layout: $current_layout"

# Check if we have a valid layout
if [[ -z "$current_layout" ]]; then
    echo "Failed to get the current layout."
    exit 1
fi

# Toggle layout based on the current layout
if [[ "$current_layout" == "English" ]]; then
    new_layout="es"
else
    new_layout="us"
fi

# Apply the new layout to all keyboards
for keyboard in $keyboards; do
    swaymsg input "$keyboard" xkb_layout "$new_layout"
done

echo "Switched to $new_layout"
