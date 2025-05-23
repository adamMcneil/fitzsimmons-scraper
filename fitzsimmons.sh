#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_with_urls>"
    exit 1
fi

INPUT_FILE="$1"
DOWNLOAD_DIR="fitzsimmons"
COUNT=0
mkdir -p "$DOWNLOAD_DIR"

# Read each URL from the file and process it
while IFS= read -r URL; do
    echo "Processing: $URL"
    wget -qO- "$URL" | grep -oP '(?<=href=")[^"]*' | grep -iE "\.pdf$" | while read -r LINK; do
        # Convert relative links to absolute
        if [[ ! "$LINK" =~ ^https?:// ]]; then
            LINK=$(echo "$URL" | sed 's#/*$##')/"$(echo "$LINK" | sed 's#^/*##')"
        fi

        FILENAME=$(basename "$URL")
        wget -O "$DOWNLOAD_DIR/$FILENAME-$COUNT.pdf" "$LINK" 2>/dev/null && echo "Downloaded: $LINK"
        ((COUNT++))
    done
done < "$INPUT_FILE"
