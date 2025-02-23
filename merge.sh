#!/bin/bash

# Check if the directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <output.pdf> [directory (default: current)]"
    exit 1
fi

OUTPUT_FILE="$1"
DIRECTORY="${2:-.}"  # Default to current directory if not provided

# Find all PDFs, sort them, and store in an array
FILES=($(find "$DIRECTORY" -maxdepth 1 -type f -name "*.pdf" | sort))

# Check if there are PDFs to merge
if [ ${#FILES[@]} -eq 0 ]; then
    echo "No PDF files found in $DIRECTORY"
    exit 1
fi

# Merge PDFs using pdfunite
pdfunite "${FILES[@]}" "$OUTPUT_FILE"

echo "Merged PDFs into: $OUTPUT_FILE"
