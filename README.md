# ePaper frame for ESP32

[![3D Printing](https://img.shields.io/badge/3D_printing-STL-green)](#)
[![ESPhome](https://img.shields.io/badge/homeassistant-ESPhome-green)](#)
[![License](https://img.shields.io/badge/license-CC%20BY--SA%204.0-blue)](http://creativecommons.org/licenses/by-sa/4.0/)

A 3D printed picture frame that shows unique pictures every day, built with ESP32/ESPhome:

## Table of Contents
- [Mechanics](#mechanics)
- [Electronics](#electronics)
- [Usage](#usage)
- [Acknowledgements](#acknowledgements)
- [Development](#development)
- [License](#license)
- [Authors](#authors)

- A robust 3D printed structure fitting into a regular 13x18cm IKEA picture frame (e.g. RÖDALM)
- can be used in portrait and landscape mode
- home assistant integration for flexible usage
- Example code (e.g. AI image generator)
- Power saving due to ESP32 deep sleep support

<img src="./print/photos/example_usage.jpg" alt="example_usage"/>

# Index
- [Mechanics](#Mechanics)
- [Electronics](#Electronics)
- [Usage: ESP home integration](#esp-home-integration)
- [Usage: home assistant automation](#home-assistant-automation)
- [Usage: AI generated image](#ai-image-generator-script)
- [Usage: Lorem picsum random picture](#lorem-picsum-picture)
- [Usage: Wallhaven picture of the day](#wallhaven-picture-of-the-day)
- [Acknowledgements](#Acknowledgements)


## Mechanics

A 3D Printed picture frame for ESP32 to be used e.g. with ESPhome for home assistant 

Renderings / Prototype:
| Front                                                | Back                                                 | Isometric |
| ---------------------------------------------------- | ---------------------------------------------------- | --------- |
| <img src="./print/front.png" alt="front"/> | <img src="./print/back.png" alt="back"/>   | <img src="./print/iso.png" alt="iso"/> |
| <img src="./print/photos/front.jpg" alt="front"/>    | <img src="./print/photos/back.jpg" alt="back"/>      | <img src="./print/photos/iso.jpg" alt="iso"/> |


### 3D-Printed Parts

| Filename       | Thumbnail                                                                       | Required |
| -------------- | ------------------------------------------------------------------------------- | -------- |
| frame_lower_clips | <img src="./print/png/frame_lower_clips.png" alt="frame"/>                         | 1 (for frames with lower clips)        |
| frame_higher_clips | <img src="./print/png/frame_higher_clips.png" alt="frame"/>                         | 1 (for frames with higher clips)      |
| display_backplate | <img src="./print/png/display_backplate.png" alt="display_backplate"/> | 1        |
| esp_box           | <img src="./print/png/esp_box.png" alt="esp_box"/>                     | 1        |
| display_cable_box | <img src="./print/png/display_cable_box.png" alt="display_cable_box"/> | 1        |
| short_grid        | <img src="./print/png/short_grid.png" alt="short_grid"/>               | optional, required for wall hanging in portrait mode |
| long_grid         | <img src="./print/png/long_grid.png" alt="long_grid"/>                 | option, required for wall hanging in landscape mode |


> **Note on IKEA picture frames:**  
> IKEA has changed the position of the wire clips on the back of their picture frames in newer batches ([see Issue #1](https://github.com/Smengerl/ePaper_frame/issues/1)).  
> Please check the position of the wire clips on your frame before printing.  
> Depending on the position, you should print either the `frame_lower_clips` **or** `frame_higher_clips` version.



### Required screws

| Name      | Spec    | Required |
| --------- | ------- | -------- |
| Screw     | M2 6mm  | 4        |
| Screw     | M2 10mm | 14       |

### Assembly

![assembly](./print/assembly.gif)

Note that you can insert the ESP in its mount facing upside down in case you want to access the GPIO pins that would otherwise be on the backside.
Also you can mount the ESP box facing the cable holder in the other direction than shown in the assembly video if this allows you for better mounting of the cable in you home.  



## Electronics

### Part list

| Unit price | Quantity | Partname | Thumbnail | Note |
| ---------- | -------- | -------- | --------- | ---- |
| 5-10 USD | 1 | ESP32 Dev Module | <img src="https://www.waveshare.com/w/upload/7/77/E-Paper-ESP32-Driver-Board-01.jpg" alt="esp32" width="300"/> | Easiest way is to use pre-assembled display boards such as [this one](https://www.waveshare.com/wiki/E-Paper_ESP32_Driver_Board) |
| 50 USD | 1 | 7,5" ePaper Display HAT | <img src="https://www.waveshare.com/w/upload/thumb/d/d9/7.5inch-e-paper-hat-b-4.jpg/450px-7.5inch-e-paper-hat-b-4.jpg" alt="ePaper" width="300"/> | There a dozens of different epaper displays available which require different configuration. I used [this one](https://www.waveshare.com/7.5inch-e-Paper-B.htm) |

*Please note that this hat has no PSRAM as most other ESP32 development boards and is therefore limited in terms of use for memory intesive graphic operations (downloading images from the web, decoding images at runtime etc) 

### Schematics

If you use the out-of-the-box solution from waveshare mentioned above, this is a working configuration and pinout for the display:
- Display model 50inV2alt
- SPI CLK: GPIO13
- SPI MOSI: GPIO14
- CS: GPIO15
- DC: GPIO27
- RESET: GPIO26 (Reset duration 2ms)
- BUSY: GPIO25 (Inverted!)

If you are using the preassembled component mentioned above, there is no need for any further wiring. Just connect the flat wire of the display to the hat and you are good to go. For further details see waveshare's wiki: https://www.waveshare.com/wiki/7.5inch_e-Paper_HAT_(B)_Manual#ESP32.2F8266


## Usage

The following examples uses the epaper picture in conjunction with ESP home showing a different picture every day or on certain triggers via home assistant. 

The approach is based on integerating the ePaper frame as a device in ESPhome.
An automation and helper scripts are used in homeassistant to generate suitable images on a certain time interval or other triggers.
In the meanwhile the ESP is set to deep sleep mode to preserve energy.



### ESP home integration

This ESPHome project configures an ePaper display as a smart and energy-efficient solution for displaying dynamic content, such as images fetched from Home Assistant. It leverages deep sleep capabilities to optimize power usage and supports features like manual refresh, automatic updates, and offline fallback modes.

Features
- Dynamic Image Display: Displays images fetched from a given URL (default: from Home Assistant local directory). Supports resizing and rendering PNG images directly on the ePaper display.
- Support for automations: Exposes actions (e.g., reload image, render) that can be used in HA automations. Actions can be used asynchronously (default) and also synchronously via waiting for callback events, see example below   
- Deep Sleep Optimization: Offers deep sleep to reduce power consumption. Can be manually woken up via boot button. Event callback to trigger subsequent automations. 
- Automatic and Manual Refresh: Option for automatic display refresh of the ePaper display at specified intervals as well as full control via manual refresh
- Offline Fallback: Displays a local "offline" image when Wi-Fi or image download fails.
- HA GUI support: Debug and configuration entities are provided in device settings in HA


Source code is under `./esphome_src`

- `/epaper_display.yaml`: main file for ESP home configuration, contains the relevant source code, imports all following packages
- `/epaper_display_packages/device_basics.yaml`: Basic hardware related configuration for ESP and display, no logic
- `/shared_packages/debug_basics.yaml`: Adds debug releated entities (optional), generic - not limited to use in this project
- `/shared_packages/deep_sleep.yaml`: Contains all deep sleep related code (optional), generic - not limited to use in this project
- `/images/offline.png`: Fallback image
- `/secrets.yaml.example`: Template for the credentials the config expects

Before flashing, copy [`esphome_src/secrets.yaml.example`](./esphome_src/secrets.yaml.example) to `[homeassistant]/config/esphome/secrets.yaml` and fill in your own values (`wifi_ssid`, `wifi_password`, `epaper_api_key`, `epaper_ota_pw`, `epaper_fallback_pw`). `secrets.yaml` is git-ignored.

### home assistant automation

You can use the ePaper ESP home device in automations in home assistant.

The following automation can serve as an example.
- Once a day at 6:00 it creates a new image and refreshes the ePaper display, then puts the frame back to deep sleep until the next day.
- As the automation is triggered by the frame coming online, waking it up manually via the boot button also triggers a fresh image.
- If image generation or rendering fails for any reason, it retries in an hour instead of leaving the frame stuck awake (draining the battery) or asleep for a full day.
- Every other wake-up (Wi-Fi reconnects outside the window, HA restarts, ...) still gets an explicit sleep command re-arming it until the next window, instead of relying on any device-side default - see the comment on `default:` in the automation below for why this matters.
- Such automation can use different image sources for which you will find some examples further below.

You also need an `input_datetime` helper (Settings → Devices & Services → Helpers → Create Helper → Date and/or time), e.g. named `epaper_last_render`. It is used to render at most once a day even if the frame reconnects to Wi-Fi several times during the morning window.

Source code for these scripts is under `./ha_scripts`

```yaml
alias: Create AI image
description: Create a fresh AI image once a day and put the frame to deep sleep until the next day.
triggers:
  # Primary path: the frame wakes ~06:00 and announces itself over the API.
  - trigger: state
    entity_id: binary_sensor.epaper_display_connection_state
    to: "on"
  - trigger: homeassistant
    event: start
  # Fallback: only matters if the frame was already awake before the time window
  # below opens (then there is no off->on edge on connection_state to trigger on).
  - trigger: time
    at: "06:00:00"
conditions:
  # Without a reachable frame, reload/sleep are pointless. Keep this the ONLY
  # automation-wide condition - see the comment on `default:` below for why
  # the render-window / once-a-day checks must NOT sit here as well.
  - condition: state
    entity_id: binary_sensor.epaper_display_connection_state
    state: "on"
actions:
  - choose:
      - conditions:
          - condition: time
            after: "05:30:00"
            before: "12:00:00"
          # Render at most once a day - guards against reconnect storms re-triggering this.
          - condition: template
            value_template: >-
              {{ state_attr('input_datetime.epaper_last_render', 'timestamp') is none
                 or state_attr('input_datetime.epaper_last_render', 'timestamp') < today_at('00:00') | as_timestamp }}
        sequence:
          # Image generation must never block the reload + deep sleep below, so continue
          # regardless of outcome - the script itself falls back to a placeholder image
          # (see generate_new_image.sh) if the AI API fails.
          - action: remote_command_line.generate_ai_image
            data: {}
            continue_on_error: true
          - delay:
              seconds: 2
          # Explicitly triggers online_image.update() -> download -> render of the image
          # that was just generated above.
          - action: esphome.epaper_display_epaper_reload_image
            data: {}
            continue_on_error: true
          - wait_for_trigger:
              # IMPORTANT: do not add `attribute: event_type` + `to: render_complete` here.
              # This event entity only ever fires ONE event type (render_complete), so that
              # attribute value never actually *changes* between two triggers - and Home
              # Assistant's state trigger only fires on a real change. Add the filter and
              # this fires once (right after flashing) and then never again, silently
              # breaking the automation from then on. Watching the bare state is enough:
              # it is the event's timestamp, which is guaranteed to change on every render.
              - trigger: state
                entity_id: event.epaper_display_rendering
            continue_on_timeout: true
            timeout:
              minutes: 4
          - if: "{{ wait.completed }}"
            then:
              - action: input_datetime.set_datetime
                target:
                  entity_id: input_datetime.epaper_last_render
                data:
                  datetime: "{{ now() }}"
          - action: esphome.epaper_display_sleep_until
            data:
              # Absolute Unix epoch (UTC). HA does the timezone/DST math, the device only
              # computes target - now. Success -> sleep until 06:00 tomorrow. Timeout above
              # -> sleep only 1h so the frame retries soon instead of getting stuck.
              target: >-
                {% set base = today_at('06:00') if today_at('06:00') > now() else today_at('06:00') + timedelta(days=1) %}
                {{ (base if wait.completed else now() + timedelta(hours=1)) | as_timestamp | int }}
    default:
      # IMPORTANT: this branch is not optional. The frame wakes up (and this
      # automation fires) far more often than once a day - Wi-Fi reconnects,
      # manual boot-button presses, HA restarts. Every one of those wake-ups
      # must get an explicit sleep_until, even the ones where nothing above
      # runs because it's outside the window or already rendered today.
      #
      # If the window / once-a-day checks instead sit as automation-wide
      # `conditions:` (so the whole automation, sleep_until included, only
      # runs when they pass), the frame stops getting any sleep command at
      # all for the rest of the day once it has rendered. It then falls back
      # to ESPHome's own run_duration safety net and whatever sleep_duration
      # is compiled into the firmware - typically far shorter than a day - so
      # it keeps waking up roughly hourly around the clock instead of
      # sleeping until the next window. Always re-arm sleep_until here.
      - action: esphome.epaper_display_sleep_until
        data:
          target: >-
            {% set base = today_at('06:00') if today_at('06:00') > now() else today_at('06:00') + timedelta(days=1) %}
            {{ base | as_timestamp | int }}
mode: single
```

### Example Scripts

#### Notes on usage

- Make sure to have the scripts set to executable via chmod
- Adapt the parameters in the script as needed
- Make the scripts usable as actions in HA automations via commandline, shell or remotecommandline addons. Note that HA command line commands must not take longer than 60s while the free tier of hugging face AI models might take longer to provide a result. You might want to use the remotecommandline addon (https://github.com/koying/ha-remote-command-line.git) instead, which allows to set a custom timeout. 
- Double check if your HA has ffmpeg installed. For this, you need to execute the command in the HA docker container, use `docker container exec homeassistant ls /usr/bin | less. Note that you need to disable protection mode in terminal to run this command. Also you might want to configure ffmpeg for homeassistant as well by adding a configuration entry in your configuration.yaml. See ffmpeg integration description.


#### AI image generator script

`ha_scripts/generate_new_image.sh`: Image Generation from Hugging Face API

This script uses a text-to-image AI to create an image for a given prompt to display this on the ePaper displays. 
It integrates with the Hugging Face Inference API (FLUX.1-schnell) to generate images based on a specified prompt, processes the resulting image, and organizes backups for future use.
- Sends a prompt to the Hugging Face model API (FLUX.1-schnell) to generate an image to display on the epaper screen a high-resolution .jpg image of the specified dimensions.
- Converts the generated .jpg image to a .png format using ffmpeg.
- Automatically creates a timestamped backup of the processed image in a designated backup directory.
- Captures detailed curl logs to trace the API call for debugging purposes

> **Note on Hugging Face free tier:**  
> The script uses the `hf-inference` provider via `https://router.huggingface.co/hf-inference/models/...`, which is HF's own native serverless backend and works with the free monthly credits included in every HF account ($0.10/month for free users, $2.00/month for PRO users).  
> Other providers such as `fal-ai` require separate pre-paid credits and will not work on the free tier.  
> As of April 2026, only **3 text-to-image models** are available on `hf-inference`:
> - `black-forest-labs/FLUX.1-schnell` — best quality, currently used
> - `stabilityai/stable-diffusion-xl-base-1.0`
> - `stabilityai/stable-diffusion-3-medium-diffusers`


#### Lorem Picsum picture

`ha_scripts/get_lorem_picsum.sh`: Get random picture from Lorem Picsum API

This script automates the process of downloading a random grayscale image from Lorem Picsum, converting it to PNG format, and backing up both the original and processed images.

- Random Image Download: Fetches a grayscale image with specified dimensions (WIDTH x HEIGHT) from Lorem Picsum. Saves the image as a .jpg file.
- Image Processing: Converts the .jpg image to .png format using ffmpeg.
- Backup Management: Creates a timestamped backup of both the original .jpg and processed .png images.


#### Wallhaven picture of the day

`ha_scripts/get_wallhaven_potd.sh`: Get picture of the day from wallhaven API

This script fetches a random image from the Wallhaven API, processes it to meet the specified dimensions and transforms it to a black-and-white images suitable for ePaper displays.

- Image Fetching: Connects to the Wallhaven API to retrieve a random image URL. Downloads the selected image to a temporary .jpg file.
- Image Processing: Dynamically calculates cropping dimensions to preserve the largest possible portion of the image while maintaining the target aspect ratio. Converts the cropped image to .png format using ffmpeg.
- Backup Management: Automatically creates a timestamped backup of both the original and processed images.


## Acknowledgements
- home assistant 
- ESP home
- hugging face




## Development

Contributions are welcome.  
See `CONTRIBUTING.md` for details and follow the `CODE_OF_CONDUCT.md` when contributing.

All .stl, .png, and assembly pictures are automatically exported via my Fusion add-in, see [here](https://github.com/smengerl/fusion-exporter)

## License

This project is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0) — see `LICENSE.txt` for details or visit http://creativecommons.org/licenses/by-sa/4.0/

## Authors

- Simon Gerlach <https://github.com/Smenger>

---

If something in this README is missing or unclear, please open an issue in the repository so the instructions can be improved.
