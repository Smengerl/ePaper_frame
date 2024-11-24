#!/bin/bash



# File name to save the final image after it was transformed to png
OUTPUT_FILENAME="/config/www/output.png" 

# File name to save the generated image
TEMP_IMAGE_FILENAME="/config/www/output.jpg"

# File name to save the curl trace
TRACE_FILENAME="/config/www/curl_log.txt" 

# Dimensions of the output image
HEIGHT=744 # need to be divisable by 8
WIDTH=480 # need to be divisable by 8

BACKUP_DIRECTORY="/config/www/backup_images" 

LOG_FILE="/config/www/log.log" 

# Redirect output to log file
exec > $LOG_FILE 2>&1



# Helper function to backup the result file 
backup_file() {
    echo "Backing up file..."
    # Backup file for later use
    mkdir $BACKUP_DIRECTORY
    #cp $TEMP_IMAGE_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $TEMP_IMAGE_FILENAME)
    cp $OUTPUT_FILENAME $BACKUP_DIRECTORY/$(date +"%Y%m%d%H%M%S").$(basename $OUTPUT_FILENAME)
}


# Helper function to convert the image to PNG while resizing and cropping it if necessary 
process_image_with_ffmpeg() {
    echo "Converting image to PNG..."
    # Calculate aspect ratio
    local aspect_ratio
    aspect_ratio=$(echo "$WIDTH / $HEIGHT" | bc -l)

    # Retrieve input image dimensions
    local dimensions
    dimensions=$(ffmpeg -i "$TEMP_IMAGE_FILENAME" 2>&1 | grep 'Stream #0' | awk -F'[ ,]' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+x[0-9]+$/) print $i}')
    local input_width
    local input_height
    input_width=$(echo "$dimensions" | cut -d'x' -f1)
    input_height=$(echo "$dimensions" | cut -d'x' -f2)

    if [ -z "$input_width" ] || [ -z "$input_height" ]; then
        echo "Failed to retrieve input dimensions."
        return 1
    fi

    # Calculate crop dimensions
    local crop_width
    local crop_height
    local offset_x
    local offset_y

    if (( $(echo "$input_width / $input_height > $aspect_ratio" | bc -l) )); then
        # Wider than target aspect ratio; adjust width
        crop_width=$(echo "$input_height * $aspect_ratio" | bc -l | awk '{print int($1+0.5)}')
        crop_height=$input_height
        offset_x=$(echo "($input_width - $crop_width) / 2" | bc -l | awk '{print int($1+0.5)}')
        offset_y=0
    else
        # Taller than target aspect ratio; adjust height
        crop_width=$input_width
        crop_height=$(echo "$input_width / $aspect_ratio" | bc -l | awk '{print int($1+0.5)}')
        offset_x=0
        offset_y=$(echo "($input_height - $crop_height) / 2" | bc -l | awk '{print int($1+0.5)}')
    fi

    echo "Crop dimensions: width=$crop_width, height=$crop_height, x=$offset_x, y=$offset_y"

    # Run ffmpeg with the calculated crop and scale
    ffmpeg -y -i "$TEMP_IMAGE_FILENAME" -vf "format=gray,crop=${crop_width}:${crop_height}:${offset_x}:${offset_y},scale=${WIDTH}:${HEIGHT}:sws_dither=bayer" -c:v png "$OUTPUT_FILENAME"

    if [ $? -eq 0 ]; then
        echo "Image processed successfully: $OUTPUT_FILENAME"
    else
        echo "Failed to process the image."
        return 1
    fi
}
