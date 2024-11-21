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
