#!/bin/bash


# Wallhaven API endpoint
API_URL="https://wallhaven.cc/api/v1/search?q=random"



# File name to save the final image after it was transformed to png
#OUTPUT_FILENAME="~/config/www/output.png" 
OUTPUT_FILENAME="/config/www/output.png" 

# File name to save the generated image
#TEMP_IMAGE_FILENAME="~/config/www/output.jpg" 
TEMP_IMAGE_FILENAME="/config/www/output.jpg"

# File name to save the curl trace
#TRACE_FILENAME="~/config/www/curl_log.txt" 
TRACE_FILENAME="/config/www/curl_log.txt" 

BACKUP_DIRECTORY="/config/www/wallhaven_backup_images" 


# Dimensions of the output image
HEIGHT=744 # need to be divisable by 8
WIDTH=480 # need to be divisable by 8



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



# Use ffmpeg to process the image into a video
echo "Converting image to PNG..."




# Constants for target aspect ratio and dimensions
ASPECT_RATIO=$(echo "$WIDTH / $HEIGHT" | bc -l)




# Determine cropping dimensions dynamically
echo "Retrieving input image dimensions..."
DIMENSIONS=$(ffmpeg -i "$INPUT_IMAGE" 2>&1 | grep 'Stream #0' | awk -F'[ ,]' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+x[0-9]+$/) print $i}')

INPUT_WIDTH=$(echo "$DIMENSIONS" | cut -d'x' -f1)
INPUT_HEIGHT=$(echo "$DIMENSIONS" | cut -d'x' -f2)
echo "Width: $INPUT_WIDTH, Height: $INPUT_HEIGHT", Dimensions: $DIMENSIONS


if [ -z "$INPUT_WIDTH" ] || [ -z "$INPUT_HEIGHT" ]; then
    echo "Failed to retrieve input dimensions."
    exit 1
fi

# Calculate crop dimensions based on aspect ratio
if (( $(echo "$INPUT_WIDTH / $INPUT_HEIGHT > $ASPECT_RATIO" | bc -l) )); then
    # Wider than target aspect ratio; adjust width
    CROP_WIDTH=$(echo "$INPUT_HEIGHT * $ASPECT_RATIO" | bc -l | awk '{print int($1+0.5)}')
    CROP_HEIGHT=$INPUT_HEIGHT
    OFFSET_X=$(echo "($INPUT_WIDTH - $CROP_WIDTH) / 2" | bc -l | awk '{print int($1+0.5)}')
    OFFSET_Y=0
else
    # Taller than target aspect ratio; adjust height
    CROP_WIDTH=$INPUT_WIDTH
    CROP_HEIGHT=$(echo "$INPUT_WIDTH / $ASPECT_RATIO" | bc -l | awk '{print int($1+0.5)}')
    OFFSET_X=0
    OFFSET_Y=$(echo "($INPUT_HEIGHT - $CROP_HEIGHT) / 2" | bc -l | awk '{print int($1+0.5)}')
fi

echo "Crop dimensions: width=$CROP_WIDTH, height=$CROP_HEIGHT, x=$OFFSET_X, y=$OFFSET_Y"


# Run ffmpeg with dynamically determined crop and scale
ffmpeg -i "$TEMP_IMAGE_FILENAME" -vf "format=gray,crop=${CROP_WIDTH}:${CROP_HEIGHT}:${OFFSET_X}:${OFFSET_Y},scale=${TARGET_WIDTH}:${TARGET_HEIGHT}:sws_dither=bayer" -c:v png "$OUTPUT_FILENAME"

# Check if the ffmpeg command succeeded
if [ $? -eq 0 ]; then
    echo "Image processed successfully: $OUTPUT_IMAGE"
else
    echo "Failed to process the image."
    exit 1
fi

echo "Image saved as $OUTPUT_FILENAME."


# Backup file for later use
mkdir $BACKUP_DIRECTORY
cp $TEMP_IMAGE_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $TEMP_IMAGE_FILENAME)
cp $OUTPUT_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $OUTPUT_FILENAME)



# rm $TEMP_IMAGE_FILENAME
echo "Temporary image removed $TEMP_IMAGE_FILENAME."