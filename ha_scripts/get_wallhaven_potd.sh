#!/bin/bash

# Variables (replace with your actual values or accept as arguments)

# Include the variables from another script
source /config/esphome/epaper_display_packages/standard_config.sh

# Wallhaven API endpoint
API_URL="https://wallhaven.cc/api/v1/search?q=random"



# Fetch random images from the Wallhaven API
echo "Fetching random images data from Wallhaven API..."
RESPONSE=$(curl -s "$API_URL")

# Extract the total number of images in the response
IMAGE_COUNT=$(echo "$RESPONSE" | jq '.data | length')

# Check if any images were found
if [ "$IMAGE_COUNT" -eq 0 ]; then
    echo "No images found or API error occurred."
    exit 1
fi

# Select a random image from the list
RANDOM_INDEX=$((RANDOM % IMAGE_COUNT))
IMAGE_URL=$(echo "$RESPONSE" | jq -r ".data[$RANDOM_INDEX].path")

# Check if the image URL was successfully extracted
if [ -z "$IMAGE_URL" ] || [ "$IMAGE_URL" == "null" ]; then
    echo "Failed to extract image URL."
    exit 1
fi

# Download the randomly selected image
curl -L -o "$TEMP_IMAGE_FILENAME" "$IMAGE_URL"

# Verify if the download was successful
if [ $? -eq 0 ]; then
    echo "Image downloaded successfully: $TEMP_IMAGE_FILENAME"
else
    echo "Failed to download the image."
    exit 1
fi


# Process the image using the helper function
process_image_with_ffmpeg 
if [ $? -ne 0 ]; then
    exit 1
fi
echo "Image saved as $OUTPUT_FILENAME."

# Backup result
backup_file 



# rm $TEMP_IMAGE_FILENAME
# echo "Temporary image removed $TEMP_IMAGE_FILENAME."