#!/bin/bash

# Variables (replace with your actual values or accept as arguments)

# URL for the API
MODEL_URL="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev" 

# Authentication token
BEARER_TOKEN="hf_xxxxxxxxxxxx" 

# Input for the model
PROMPT="A high-contrast black-and-white comic-style illustration designed for ePaper display, showing a family of five in a single everyday situation. \
They are engaging in an activity together. The setting and activity are left open-ended, allowing for a natural depiction of a family moment. \
The artwork features bold outlines, minimal shading, and a clean, simple style to ensure clear readability on the ePaper display."

# File name to save the final image after it was transformed to png
#OUTPUT_FILENAME="~/config/www/output.png" 
OUTPUT_FILENAME="/config/www/output.png" 

# File name to save the generated image
#TEMP_IMAGE_FILENAME="~/config/www/output.jpg" 
TEMP_IMAGE_FILENAME="/config/www/output.jpg"

# File name to save the curl trace
#TRACE_FILENAME="~/config/www/curl_log.txt" 
TRACE_FILENAME="/config/www/curl_log.txt" 

BACKUP_DIRECTORY="/config/www/epaper_backup_images" 


# Dimensions of the output image
HEIGHT=744 # need to be divisable by 8
WIDTH=480 # need to be divisable by 8



#cd /config/www

# Step 1: Use curl to fetch the image
echo "Fetching image from API..."
curl \
  --trace-ascii "$TRACE_FILENAME" --trace-time \
  -X POST \
  "$MODEL_URL" \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer '$BEARER_TOKEN \
  --output "$TEMP_IMAGE_FILENAME" \
  -d "{\
    \"inputs\": \"$PROMPT\",\
    \"parameters\": {\
      \"height\": $HEIGHT,\
      \"width\": $WIDTH\
    }\
  }"

# Check if curl succeeded
if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch image from the API."
  exit 1
fi

echo "Image saved as $TEMP_IMAGE_FILENAME."



# Step 2: Use ffmpeg to process the image into a video
echo "Converting image to PNG..."
ffmpeg -y -i "$TEMP_IMAGE_FILENAME" -c:v png "$OUTPUT_FILENAME"

# Check if ffmpeg succeeded
if [ $? -ne 0 ]; then
  echo "Error: Failed to convert image to PNG."
  exit 1
fi

echo "Image saved as $OUTPUT_FILENAME."


# Backup file for later use
mkdir $BACKUP_DIRECTORY
#cp $TEMP_IMAGE_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $TEMP_IMAGE_FILENAME)
cp $OUTPUT_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $OUTPUT_FILENAME)



# rm $TEMP_IMAGE_FILENAME
echo "Temporary image removed $TEMP_IMAGE_FILENAME."
