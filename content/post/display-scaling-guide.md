---
title: "Display Scaling Guide"
date: 2022-11-04
tags: 
    - guide
    - software
    - windows
---
`DISLAIMER: if you want to setup custom resolution with display scaling using this guide and your monitor has G-SYNC, this guide will not work for you due to G-SYNC monitors only supporting common resolutions e.g. 1280x720, ...`

this article will cover how to make your monitor scale the output image instead of your gpu, which will result in sharper image[^3] and negligible[^1] latency improvement. it can also fix issues with games changing your monitor's refresh rate to 60hz.

i believe you can set this up on any monitor (read disclaimer at the top of the page), but make sure to check your monitor osd first and look for something like `display mode` or `picture format`, you will later use this setting to scale the game however you like it (stretched/black bars).

pros/cons:
- (+) sharper image[^3]
- (+) fixes games changing refresh rate
- (+) input latency improvement[^1]
- (-) longer alt-tab times[^2]

prerequisites:
- [cru-1.5.2.zip](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU)

download custom resolution utility and extract it, the archive will also come with other useful programs[^4]. make sure you **KEEP THEM**, they are necessary in the process of setting up and getting you recovered if anything goes wrong.

open custom resolution utility, open the extension block at the bottom and you will see a list of resolutions: 

![extension block cru](/img/CRU_2jXjoOW4pJ.png)

`! if your monitor is above 655.35 MHz pixel clock (~280hz @ 1080P), you will have to add your resolutions in an extension block Display ID 1.3 (or 2.0) !`

click on your native resolution (e.g. 1920x1080@240), open it and click copy in the top right, exit out and click add in detailed resolutions (read above if your monitor is 280hz or higher), then paste in the top right.

now you can delete any other resolution, default extension block and other extension block that you didn't set up by clicking delete all or none on everything, only keep your newly added native resolution in the detailed resolutions tab (or extension block).

add any resolutions you play on in detailed resolutions tab (or extension block), timing - `exact reduced`:

![720p resolution cru](/img/CRU_xkrhtsmLgl.png)

exit out of cru by clicking OK and run `restart64.exe` as an admin, if anything goes wrong and you don't see any image - press `F8`, your display will go into safe mode and you will be able to change the settings or reset to default[^4].

make sure you either have `aspect ratio` or `no scaling` set in your gpu control panel, otherwise this won't work, you can always check your monitor osd if display scaling works by checking your active resolution (if it matches the one you have set in-game and is lower than your native -> display scaling is working)

and that's everything, your monitor will now take care of scaling your image.

![cru final example](/img/CRU_example.png)

(if you have any issues try reading through the [thread](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) on monitor tests forum)

[^1]: some sources state that there's a negligible input latency improvement due to gpu adding tiny bit of delay when scaling your image (<1ms) - not humanly noticeable :-)

[^2]: if your resolution on desktop and in-game is mismatched it will take longer to alt-tab due to the monitor having to change it's resolution everytime you exit your game (e.g. 1280x720 -> 1920x1080). this can be completely avoided by changing your desktop resolution to the one you have set in-game. make sure you change the resolution with your gpu control panel, changing the resolution in windows settings will not change it properly!

[^3]: how sharp the image will be depends on the quality of your monitor's scaler, different monitors will have different results, i tried this on my zowie xl2546 and asus xv252q and the image was significantly sharper on my zowie xl2546.

[^4]: reset-all.exe - resets all your monitor settings back to default, restart64.exe - restarts your gpu drivers + opens safe menu.