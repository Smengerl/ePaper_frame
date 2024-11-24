#!/bin/bash

# Variables (replace with your actual values or accept as arguments)

# Include the variables from another script
source /config/esphome/epaper_display_packages/standard_config.sh



# Download the image using curl
echo "Downloading random image from Lorem Picsum..."
curl -L --trace-ascii "$TRACE_FILENAME" --trace-time https://picsum.photos/$WIDTH/$HEIGHT?grayscale --output "$TEMP_IMAGE_FILENAME"


# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Image downloaded successfully as $TEMP_IMAGE_FILENAME."
else
    echo "Failed to download the image."
    exit 1
fi


# Process the image using the helper function
process_image_with_ffmpeg 

# Backup result
backup_file 



# rm $TEMP_IMAGE_FILENAME
# echo "Temporary image removed $TEMP_IMAGE_FILENAME."
