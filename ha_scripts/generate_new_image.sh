#!/bin/bash

# Variables (replace with your actual values or accept as arguments)

# Include the variables from another script
source standard_config.sh
source hugging_face_bearer_token.sh

# URL for the API
MODEL_URL="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev" 



DAY_NUMBER=$(date +"%u") # 1=Monday, 7=Sunday
DAY=$(date +"%d")

# Current season based on the month
MONTH=$(date +"%m")






if [[ "$MONTH" -eq 12 || "$MONTH" -le 2 ]]; then
  SEASON="Winter"
  SEASON_ELEMENTS="Snow-covered trees, bare branches glistening with frost, icicles hanging from rooftops, snowfalls blanketing the ground, frosty mornings with visible breath, cold nights under a starry sky"
elif [[ "$MONTH" -ge 3 && "$MONTH" -le 5 ]]; then
  SEASON="Spring"
  SEASON_ELEMENTS="blooming flowers, fields of daffodils and tulips, trees with fresh green leaves, crisp and fresh air"
elif [[ "$MONTH" -ge 6 && "$MONTH" -le 8 ]]; then
  SEASON="Summer"
  SEASON_ELEMENTS="Lush green trees with thick foliage, sunflowers, blooming lavender fields, sunny days with clear blue skies"
else
  SEASON="Autumn"
  SEASON_ELEMENTS="Trees with leaves in colorful shades, fallen leaves, pumpkins and gourds in patches, harvested cornfields, crisp air with morning fog, golden afternoon light, gentle autumn breezes carrying leaves"
fi


IS_WORKDAY=false
case "$DAY-$MONTH" in
    "31-12"|"01-01") 
      SEASON="New year's day"
      SEASON_ELEMENTS="Clocks and Watches, Calendar Pages, Confetti and Balloons, Fireworks, Year Numbers, sparkling wine, family dinner."
      ;;
    "03-10") 
      SEASON="German unity day"
      SEASON_ELEMENTS="German Flags, Berlin Wall, Maps of divided Germany,  Bundesadler, Handshake, Reichstag Building, brandenburg gate, Chains Breaking"
      ;;
    "30-10") 
      SEASON="Halloween"
      SEASON_ELEMENTS="Witches, jack-o-lanterns, spiders webs, bats, skulls, bones and other typical decoration."
      ;;
    "24-12"|"25-12"|"26-12") 
      SEASON="Christmas"
      SEASON_ELEMENTS="Candles, wreaths, twinkling christmas lights, candy canes, caubles, snowflakes, Santa Claus, Reindeer, Elves, Angels"
      ;;
    *)
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
        TIME_OF_THE_DAY="in the morning"
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
        TIME_OF_THE_DAY="in the morning"
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
        TIME_OF_THE_DAY="in the afternoon"
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
        TIME_OF_THE_DAY="in the evening"
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
        TIME_OF_THE_DAY="in the morning"
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
        TIME_OF_THE_DAY="at daytime"
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
        TIME_OF_THE_DAY="in the evening"
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

RENDERING_ADVISE="A high-contrast black-and-white comic-style illustration featuring bold outlines, minimal shading, and a clean, simple style to ensure clear readability on an ePaper display."



# A high-contrast black-and-white comic-style illustration designed for ePaper display, showing a family of five in a single everyday situation. \
# They are engaging in an activity together. The setting and activity are left open-ended, allowing for a natural depiction of a family moment. \

# The scene includes rich details such as seasonal elements like blooming flowers for Spring, fallen leaves for Autumn, or snowflakes in Winter. \
# If the activity takes place indoor, these details are only seen through the windows. \

# Input for the model
PROMPT="$RENDERING_ADVISE \
The picture shows a family of five $TIME_OF_THE_DAY $SETTING, $ACTIVITY. \
The scene captures the warmth, emotions, and connections between family members. \
The scene shall refer to $SEASON and includes rich details such as seasonal elements like some of these examples: $SEASON_ELEMENTS. \
The father is tall and slender with brown wavy hair. \
The mother is slightly shorter with glasses and shoulder-length red hair. \
The first child is a boy of 12 years with short brown hair in a side cut. \
The second child is a 10 year old girl with long, curly blonde hair. \
The third child is a 7 year old boy with blonde hair."



###########################################################
# Advent calendar special mode during december
###########################################################
if [ $MONTH -eq 12 ]; then
  if [ $DAY -lt 24 ]; then
    PROMPT="$RENDERING_ADVISE \
The picture shows a close-up view on a part of a paper advent calendar. \
The image focuses on the calendar door for the current day, $DAY, and shows fractions of other doors. \
The door in focus is wide open and shows the number $DAY on the inside of the opened door. \
It reveals that the elf-on-the-shelf is living in the calendar and gives a view into what seems to be a room of the elf house. \
The elf is in there busy in a all-day activity like cooking or crafting which is shown with rich details. \
The whole scene is humorous and ironic as the elf seems to be chaotic."

    echo "Advent mode!"

  elif [ $DAY -eq 24 ]; then
    PROMPT="$RENDERING_ADVISE \
The picture shows a close-up view on a part of a paper advent calendar. \
The image focuses on the calendar door for December 24th and shows fractions of other doors. \
The door in focus is wide open and shows the number 24 on the inside of the opened door. \
It reveals an enormous christmas tree. \
The whole scene is humorous."

    echo "Christmas mode!"
  fi
fi


#The whole scene looks as if the elve was caught by surprise when the door was opened.
#The picture shows two doors of an advent calendar. \
#One door represents the current day, $DAY, and is open. \
#The other door represents the next day, $next_date, and remains closed. \ 
#The focus of the image is on the opened lower door as it reveals that a christmas elve is living in there. \ 
#The elve seems to be busy in a all-day activity like cooking, sleeping, watching TV, crafting, ironing or doing paper work. \
#The scene is humorous and ironic as the elve seems to be chaotic and also surprised as if he was caught when the door was opened."
# The scene is warm and cozy, with Christmas decorations like candles, Wreaths, twinkling christmas lights, candy canes, caubles, snowflakes, Santa Claus, Reindeer, Elves, Angel in the background.





echo "Prompt: $PROMPT"
echo "--------------------------"


# Step 1: Use curl to fetch the image
echo "Fetching image from API..."

# Enable debug mode to print commands before execution
set -x
curl \
  --trace-ascii "$TRACE_FILENAME" --trace-time \
  -X POST \
  "$MODEL_URL" \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer '$BEARER_TOKEN \
  --output "$TEMP_IMAGE_FILENAME" \
  -d "{\
\"parameters\": {\
\"height\": $HEIGHT,\
\"width\": $WIDTH\
}, \
\"inputs\": \"$PROMPT\"\
}"

# Disable debug mode to stop printing commands
set +x


# Check if the download was successful
if [ $? -eq 0 ]; then

    # Validate if the file contains JSON
    if jq empty "$TEMP_IMAGE_FILENAME" >/dev/null 2>&1; then

      # Attempt to retrieve the specified field
      json_error_value=$(jq -r --arg field "error" '.[$field]' "$TEMP_IMAGE_FILENAME")
      
      # Check if the field is null (not found)
      if [[ "$json_error_value" != "null" ]]; then
          echo "Error: $json_error_value"
      fi

      echo "Hugging Face API returned JSON error"
      exit 1

    else
      echo "Image downloaded successfully as $TEMP_IMAGE_FILENAME."
    fi
else
    echo "Failed to download the image."
    exit 1
fi



# Process the image using the helper function
process_image_with_ffmpeg 

# Backup result
backup_file 

