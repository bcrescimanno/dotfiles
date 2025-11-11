#!/bin/bash

location=$(cat "$HOME/dotfiles/secrets/location")
service="wttr.in/$location"

# Format guide for wttr.in: https://github.com/chubin/wttr.in?tab=readme-ov-file#one-line-output
format="%c+%C+%t+%S+%s"

##########################################################################################

weather=$(curl -fs "$service?format=$format")

if [[ $? -ne 0 ]]; then
    echo "Failed to retrieve weather from wttr.in"
    exit 1
fi

sunrise=$(awk '{print $(NF-1)}' <<< $weather)
sunrise=$(date -d "$sunrise" +%s)
sunset=$(awk '{print $NF}' <<< $weather)
sunset=$(date -d "$sunset" +%s)
now=$(date +%s)

to_night_emoji() {
    case "$1" in
        "☀️") echo "🌙" ;;
        "🌤️") echo "🌙" ;;
        "⛅") echo "☁️" ;;
        "🌥️") echo "☁️" ;;
        "🌦️") echo "🌧️" ;;
        "🌧️") echo "🌧️" ;;
        "🌨️") echo "🌨️" ;;
        "⛈️") echo "⛈️" ;;
        "🌪️") echo "🌪️" ;;
        "🌈") echo "🌙" ;;
        *) echo "$1" ;;  # fallback: unchanged
    esac
}

# Swap the emoji since wttr.in always uses daytime emoji
if (( now < sunrise || now > sunset)); then
    emoji=$(awk '{print $1}' <<< "$weather")
    final_emoji=$(to_night_emoji $emoji)
    weather=${weather//$emoji/$final_emoji}
fi

# Always ignore the last two fields as they are the timestamps
weather=$(awk '{
    for (i = 1; i <= NF-2; i++) {
        printf"%s%s", $i, (i < NF-2 ? OFS :ORS)
    }
}' <<< $weather)

# I think having +70F is silly
weather=${weather//\+/}

echo $(echo "$weather" | jq -R '{text: .}')
