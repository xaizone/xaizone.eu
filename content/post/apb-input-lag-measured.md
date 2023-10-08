---
title: "APB Reloaded Input Lag Measured"
date: 2023-10-08T20:23:47+02:00
tags:
  - gaming
description: "I tested APB Reloaded input latency difference between double buffering ON and OFF."
---

Hey,

I recently got a new monitor, the Asus PG27AQN, which conveniently also includes the NVIDIA Reflex Latency Analyzer tool. A built-in tool which to some extend replaces the NVIDIA LDAT, it only measures the PC + Display latency, not the whole system latency (unless you have supported mice and you are on NVIDIA). This APB Reloaded latency test was my first experimentation with this technology, so until I refine my testing methodology you should take this stuff with a grain of salt. 

Setup:
- CPU: CPU: AMD Ryzen 7 7800X3D @ PBO -20
- GPU: ASROCK Radeon RX 7900 XTX Phantom Gaming 24GB OC
- RAM: Patriot Viper Xtreme 5 RGB (2 x 16 GB) DDR5-7600 CL36 @ 6200MHz 30-36-36-30
- Monitor: Asus ROG Swift 360Hz PG27AQN @ 1440p360, ULMB2 PW 100
- Mouse: Wired Logitech G Pro X Superlight @ 800 DPI, 1000 HZ
- OS: Windows 10 LTSC 21H2

Game specific information:
- Financial - Strega Bloodrose N corner, facing NW - "emptier" district
- Used N-TEC 5 Dvah Stock
- [Game config (enabled muzzleflash + no GC)](https://github.com/xaizone/apb-reloaded)
- Launch options: -nosteam -nomovies -nosplash -language=1031

Glossary:
- DB = Double Buffering

You are able to download these findings as an ODF Spreadsheet here - [apb-input-latency.ods](/doc/apb-input-latency.ods)

I extracted the most important values from the test in the table below. You can find more useful information in the sheet itself.

|     |No FPS limit + DB ON|No FPS limit + DB OFF |128 FPS limit + DB ON |128 FPS limit + DB OFF |
|:----|:-------------------|:---------------------|:---------------------|:----------------------|
|MIN  |4.60                |4.50                  |14.00                 |12.80                  |
|MAX  |8.50                |7.80                  |21.50                 |21.70                  |
|AVG  |6.17                |6.42                  |17.73                 |17.50                  |
|STDEV|0.971562            |0.823752              |2.073789              |2.289651               |
|NOTES|~800FPS AVG         |~700FPS AVG|

With these findings, I came to a conclusion that it's beneficial to always keep double buffering enabled as it doesn't seem to add any input latency on AMD-based systems even in FPS locked scenarios. This may vary from system to system, I have yet to conduct this testing on any Intel-based systems.

Hopefully you found this information helpful. See you next time.