#!/bin/bash


# File name to save the final image after it was transformed to png
OUTPUT_FILENAME="/config/www/output.png" 

# File name to save the generated image
#TEMP_IMAGE_FILENAME="~/config/www/output.jpg" 
TEMP_IMAGE_FILENAME="/config/www/output.jpg"

# File name to save the curl trace
#TRACE_FILENAME="~/config/www/curl_log.txt" 
TRACE_FILENAME="/config/www/curl_log.txt" 

BACKUP_DIRECTORY="/config/www/lorem_picsum_backup_images" 


# Dimensions of the output image
HEIGHT=744 # need to be divisable by 8
WIDTH=480 # need to be divisable by 8




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

echo "Image saved as $TEMP_IMAGE_FILENAME."



# Step 2: Use ffmpeg to process the image into a video
echo "Converting image to PNG..."
#ffmpeg -y -i "$TEMP_IMAGE_FILENAME" -vf format=gray,maskfun=low=128:high=128:fill=0:sum=128 -c:v png "$OUTPUT_FILENAME"
ffmpeg -y -i "$TEMP_IMAGE_FILENAME" -c:v png "$OUTPUT_FILENAME"

# Check if ffmpeg succeeded
if [ $? -ne 0 ]; then
  echo "Error: Failed to convert image to PNG."
  exit 1
fi

echo "Image saved as $OUTPUT_FILENAME."


# Backup file for later use
mkdir $BACKUP_DIRECTORY
cp $TEMP_IMAGE_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $TEMP_IMAGE_FILENAME)
cp $OUTPUT_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $OUTPUT_FILENAME)



# rm $TEMP_IMAGE_FILENAME
echo "Temporary image removed $TEMP_IMAGE_FILENAME."
