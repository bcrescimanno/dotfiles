#!/bin/bash

# TODO: Fix the direct reference here
DIR="${1:-$HOME/Pictures/4kwp}"

WP=$(find "$DIR" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
  -iname "*.gif" -o -iname "*.bmp" -o -iname "*.webp" -o \
  -iname "*.tiff" \
\) | shuf -n 1)

if [[ -z "$WP" ]]; then
    echo "No image files found in '$DIR'"
    exit 1
else
    echo "$WP"
    hyprctl hyprpaper reload ,"$WP"
fi
