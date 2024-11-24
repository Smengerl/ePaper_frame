#!/bin/bash

# Variables (replace with your actual values or accept as arguments)

# Include the variables from another script
source standard_config.sh

# URL for the API
MODEL_URL="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev" 

# Authentication token
BEARER_TOKEN="hf_xxxxxxxxxxxx" 



DAY_NUMBER=$(date +"%u") # 1=Monday, 7=Sunday
DAY=$(date +"%d")

# Current season based on the month
MONTH=$(date +"%m")
if [[ "$MONTH" -eq 12 || "$MONTH" -le 2 ]]; then
  SEASON="Winter"
elif [[ "$MONTH" -ge 3 && "$MONTH" -le 5 ]]; then
  SEASON="Spring"
elif [[ "$MONTH" -ge 6 && "$MONTH" -le 8 ]]; then
  SEASON="Summer"
else
  SEASON="Autumn"
fi


IS_WORKDAY=false
case "$MONTH-$DAY" in
    "31-12"|"01-01") 
      PUBLIC_HOLIDAY_SCENE="There should be a reference to new year's day such as sparkling wine, fireworks, family dinner."
      ;;
    "10-03") 
      PUBLIC_HOLIDAY_SCENE="There should be a reference to german unity day such as flags."
      ;;
    "24-12"|"25-12"|"26-12") 
      PUBLIC_HOLIDAY_SCENE="There should be a reference to christmas such as presents, a christmas tree, presents."
      ;;
    *)
      PUBLIC_HOLIDAY_SCENE=""
      case $DAY_NUMBER in
          1|2|3|4|5)
              IS_WORKDAY=true
              ;;
          6)
              ;;
          7)
              ;;
      esac
      ;;
esac



# Determine the time of day
HOUR=$(date +"%H") # 24-hour format

if [ "$IS_WORKDAY" = true ]; then

    # Workday activities
    if [ "$HOUR" -ge 0 ] && [ "$HOUR" -lt 8 ]; then
        ACTIVITIES=( 
          "Having breakfast" 
          "preparing the school bags"
          "waking up"
          "brush teeth"
          "Leaving for school and work"
          )
        SETTINGS=(
          "in a cozy home" 
          "in their kitchen preparing food" 
          "in their bedrooms" 
          "in their living room" 
          "at the front door" 
          "on their driveway"
          )
    elif [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 12 ]; then
        ACTIVITIES=( 
          "studying at home" 
          "doing chores together" 
          "making school projects" 
          "enjoying a snack break"
          "Coming home from school" 
          "Doing their homework"
          "Having lunch together"
          )
        SETTINGS=(
          "in a cozy living room" 
          "at the family table" 
          "in the home office" 
          "in their study room" 
          "in a sunny backyard"
          )
    elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
        ACTIVITIES=( 
          "having coffee and biskuits"
          "engaging in a fun activity together" 
          "having a heartfelt conversation" 
          "enjoying a family meal" 
          "laughing and sharing stories" 
          "playing games together" 
          "working on a creative project" 
          "celebrating a special occasion" 
          "cuddling with their pets" 
          "Coming home from school" 
          "Doing their homework"
          "Having lunch together"
          "working on crafts" 
          "gardening" 
          "helping with homework" 
          "playing outdoor games"
          )
        SETTINGS=(
          "in their backyard" 
          "at a park" 
          "in the kitchen" 
          "on the patio" 
          "in their family room"
          "outdoors in a park" 
          "at a playground" 
          "on their front porch" 
          )
    else
    # elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 24 ]; then
        ACTIVITIES=( 
          "engaging in a fun activity together" 
          "having a heartfelt conversation" 
          "enjoying a family meal" 
          "laughing and sharing stories" 
          "working on a creative project" 
          "celebrating a special occasion" 
          "having dinner together" 
          "playing board games" 
          "watching a movie" 
          "discussing the day" 
          "planning tomorrow"
          )
        SETTINGS=(
          "in their dining room" 
          "in the living room" 
          "on the couch" 
          "in their family room" 
          "at the dinner table"
          )
    fi



else

    # Weekend activities
    if [ "$HOUR" -ge 0 ] && [ "$HOUR" -lt 10 ]; then
        ACTIVITIES=( 
          "sleeping in" 
          "enjoying brunch" 
          "reading books" 
          "making pancakes" 
          "drinking coffee"
          )
        SETTINGS=(
          "in their kitchen" 
          "in bed" 
          "in the living room" 
          "on their patio" 
          "in the garden"
          "in a cozy home" 
          )
    elif [ "$HOUR" -ge 10 ] && [ "$HOUR" -lt 18 ]; then
        ACTIVITIES=( 
          "going on a picnic"
          "exploring nature" 
          "having a barbecue" 
          "playing sports" 
          "visiting relatives"
          "having coffee and biskuits"
          "celebrating a special occasion" 
          )
        SETTINGS=(
          "at a park" 
          "by a lake" 
          "on a family hike" 
          "in their backyard" 
          "at a playground"
          "at a bustling market" 
          "on a family hike" 
          "on a beach during vacation" 
          "at a playground" 
          )
    else
    # elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 24 ]; 
        ACTIVITIES=(
          "roasting marshmallows" 
          "stargazing" 
          "playing video games" 
          "cooking together" 
          "having a family movie night" 
          "engaging in a fun activity together" 
          "having a heartfelt conversation" 
          )
        SETTINGS=(
          "by the fireplace" 
          "in the family room" 
          "under the stars" 
          "in their kitchen" 
          "on the couch"
          "outdoors in a park" 
          "in their garden"
          "in the city" 
          "at a festive holiday market"
          )
    fi
fi



# Randomize the selection
SETTING=${SETTINGS[$RANDOM % ${#SETTINGS[@]}]}
ACTIVITY=${ACTIVITIES[$RANDOM % ${#ACTIVITIES[@]}]}


# A high-contrast black-and-white comic-style illustration designed for ePaper display, showing a family of five in a single everyday situation. \
# They are engaging in an activity together. The setting and activity are left open-ended, allowing for a natural depiction of a family moment. \

# Input for the model
PROMPT="A detailed and artistic depiction of a family of five $SETTING during $SEASON, $ACTIVITY. \
$PUBLIC_HOLIDAY_SCENE \
The image captures the warmth, emotions, and connections between family members, emphasizing the season's unique atmosphere. \
The scene includes rich details such as seasonal elements like blooming flowers for Spring, fallen leaves for Autumn, or snowflakes in Winter. \
The artwork is a high-contrast black-and-white comic-style illustration designed for ePaper display. \
It features bold outlines, minimal shading, and a clean, simple style to ensure clear readability on the ePaper display."


echo "Prompt: $PROMPT"

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


# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Image downloaded successfully as $TEMP_IMAGE_FILENAME."
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

