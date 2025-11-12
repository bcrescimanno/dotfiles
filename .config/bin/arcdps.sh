#!/bin/bash

read -r DIR < "$HOME/dotfiles/secrets/gw2_directory"

if [ -d "$DIR" ]; then
	FILE="$DIR/d3d11.dll"
	curl -z "$FILE" -o "$FILE" https://www.deltaconnected.com/arcdps/x64/d3d11.dll
	echo "Finished checking update"
fi
