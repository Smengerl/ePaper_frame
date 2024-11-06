# <img src="./redering/hexapod-logo.svg" alt="logo" width="64"/> Hexapod

A 3D Printed picture frame

![hexapod_model](./images/hexapod_model.jpg)

![booting_up](./images/booting_up.gif)

## Introduction

A 3D printed picture frame, built with ESP32/ESPhome:

- A robust structure
- home assistant integration
- Example code

## Electronics

| Name                       | Thumbnail                                                                | Required          | Note      |
| -------------------------- | ------------------------------------------------------------------------ | ----------------- | --------- |
| ESP32 Dev Module           | <img src="./images/esp32.jpg" alt="esp32" width="300"/>                  | 1                 |           |
| 7,5" ePaper Display HAT    | <img src="https://www.waveshare.com/w/upload/thumb/d/d9/7.5inch-e-paper-hat-b-4.jpg/450px-7.5inch-e-paper-hat-b-4.jpg" alt="ePaper" width="300"/>  | 1                 |           |

### Connection Diagram

TBD
![diagram](./images/diagram.svg)

## Assembly

![whole_assembly](./images/assembly_whole.gif)

### 3D-Printed Parts

![body_assembly](./rendering/assembly.avi)

| Filename       | Thumbnail                                                                                   | Required |
| -------------- | ------------------------------------------------------------------------------------------- | -------- |
| frame             | <img src="./print/rendering/frame.png" alt="frame" width="300"/>                         | 1        |
| display_backplate | <img src="./print/rendering/display_backplate.png" alt="display_backplate" width="300"/> | 1        |
| esp_box           | <img src="./print/rendering/esp_box.png" alt="esp_box" width="300"/>                     | 1        |
| display_cable_box | <img src="./print/rendering/display_cable_box.png" alt="display_cable_box" width="300"/> | 1        |
| short_grid        | <img src="./print/rendering/short_grid.png" alt="short_grid" width="300"/>               | optional, required for wall hanging in portrait mode |
| long_grid         | <img src="./print/rendering/long_grid.png" alt="long_grid" width="300"/>                 | option, required for wall hanging in landscape mode |

#### Required screws

| Name      | Spec    | Required |
| --------- | ------- | -------- |
| Screw     | M2 6mm  | 4        |
| Screw     | M2 10mm | 14       |

## ESP home yaml

TBD
![hexapod_model_label](./images/hexapod_model_label.svg)

## home assistant configuration

TBD
![hexapod_model_label](./images/hexapod_model_label.svg)
