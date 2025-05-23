#!/bin/bash

# Set the base URL
BASE_URL="https://thepsalmsproject.com/chords"

# Create a directory to store the downloaded PDFs
mkdir -p psalms_project
cd psalms_project || exit

# Fetch the HTML content of the chords page
curl -s "$BASE_URL" > page.html

# Extract all PDF links from the HTML content
grep -Eo 'href="[^"]+\.pdf"' page.html | \
    sed -E 's/href="([^"]+)"/\1/' | \
    while read -r pdf_url; do
        # Handle relative URLs
        if [[ "$pdf_url" != http* ]]; then
            full_url="https://thepsalmsproject.com$pdf_url"
        else
            full_url="$pdf_url"
        fi

        # Download the PDF file
        echo "Downloading $full_url"
        wget "$full_url"
    done

# Clean up
rm page.html
