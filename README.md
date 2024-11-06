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

| Filename       | Thumbnail                                                               | Required |
| -------------- | ----------------------------------------------------------------------- | -------- |
| body_top       | <img src="./images/body_top.jpg" alt="body_top" width="300"/>           | 1        |
| body_base      | <img src="./images/body_base.jpg" alt="body_base" width="300"/>         | 1        |
| body_side      | <img src="./images/body_side.jpg" alt="body_side" width="300"/>         | 2        |
| body_front_back| <img src="./images/body_front_back.jpg" alt="body_front_back" width="300"/>| 2        |
| body_battery   | <img src="./images/body_battery.jpg" alt="body_battery" width="300"/>     | 1        |
| body_servo_side1 | <img src="./images/body_servo_side1.jpg" alt="body_servo_side1" width="300"/> | 6        |
| body_servo_side2 | <img src="./images/body_servo_side2.jpg" alt="body_servo_side2" width="300"/> | 6        |
| body_servo_top   | <img src="./images/body_servo_top.jpg" alt="body_servo_top" width="300"/>     | 6        |

#### Required screws

| Name      | Spec    | Required |
| --------- | ------- | -------- |
| Screw     | M2 6mm  | 36       |
| Screw     | M2 10mm | 198      |
| Nuts      | M2      | 234      |
| Pin (304) | M4 6mm  | 18       |
| Bearing   | MR74-2RS (4mm ID, 7mm OD, 2.5mm Bore) | 18 |

## ESP home yaml

TBD
![hexapod_model_label](./images/hexapod_model_label.svg)

## home assistant configuration

TBD
![hexapod_model_label](./images/hexapod_model_label.svg)
