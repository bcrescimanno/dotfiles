#!/usr/bin/sh

# Slideshow directory
DIR="$HOME/Pictures/4kwp/"

# Get a random Wallpaper
WP=$(find "$DIR" -type f | shuf -n 1)

# Set the wallpaper
hyprctl hyprpaper reload ,"$WP"
