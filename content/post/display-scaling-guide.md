---
title: "Display Scaling Guide"
date: 2022-11-04
tags: 
  - guide
  - software
  - gaming
description: "Force your display to scale non-native resolutions using CRU (Custom Resolution Utility)."
---
`DISLAIMER: If you want to setup custom resolution with display scaling using this guide and your monitor has G-SYNC, this guide will not work for you due to G-SYNC monitors only supporting common resolutions e.g. 1280x720, ...`

This guide will cover how to make your display scale non-native resolutions instead of your gpu, which will result in sharper image[^3] and negligible[^1] latency improvement. Setting this up can also fix the issue with games changing your monitor's refresh rate.

I believe you can set this up on any monitor `(READ DISCLAIMER AT THE TOP)`, but to make sure check your monitor's menu (OSD) first and look for `Display mode` or `Picture format` (or something similar). You will later use this setting to scale the image (stretched, blackbars, ...).

Plus:
- Sharper image[^3]
- Eliminates games changing refresh rate
- Input latency improvement[^1]

Minus:
- Longer Alt+Tab[^2]

Prerequisites:
- [CRU (Custom Resolution Utility)](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU)

Download CRU (Custom Resolution Utility) and extract it. The archive will contain other useful programs[^4]. **KEEP THEM**, they are necessary in the process of setting up and getting you recovered if anything goes wrong.

Open CRU (Custom Resolution Utility), click and open the extension block at the bottom and you will see a list of resolutions: 

![Default Extension Block in CRU](/img/CRU_2jXjoOW4pJ.png)

`! ATTENTION ! If the resolution you want to use is above 655.35 MHz pixel clock (~280hz @ 1080P), you will have to add your resolutions in an extension block - Display ID 1.3 (or 2.0) !`[^5]

Click on your native resolution (e.g. 1920x1080@240), open it and click copy in the top right, exit out and click add in detailed resolutions (or in an extension block -> detailed resolutions), then paste in the top right.

Now you can delete any other resolution and/or unnecessary extension blocks. Only keep your newly added native resolution.

Add the resolution you play on in the detailed resolutions tab (or extension block as described above) and use timing - `exact reduced`:

![Adding Non-Native Resolution in CRU](/img/CRU_xkrhtsmLgl.png)

Exit out of CRU (Custom Resolution Utility) by clicking OK and run `restart64.exe`[^4] as an administrator, if anything goes wrong and you don't see your desktop - press `F8`. This will switch your display safe mode and you will be able to change the settings or reset[^4] to default.

Make sure you either have `aspect ratio` or `no scaling` set in your GPU's control panel, otherwise any of this this won't work. You can always check your monitor osd if display scaling works by checking your active resolution, if it matches the one you have set in-game and is lower than your native -> display scaling is working!

and that's everything. Use your monitor's OSD to change the way the image gets scaled.

Tip[^2]: If you hate the longer Alt+Tab times, you can completely eliminate this extra delay by changing your desktop resolution to the one you are using in-game.

![Final CRU Setup Example](/img/CRU_example.png)

If you have any issues try reading through the thread on Monitor Tests forum.

> https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU

[^1]: Different sources state that making your display scale your non-native resolutions gives you a negligible input latency improvement, the GPU is adding a tiny bit of delay (<1ms)

[^2]: If your desktop resolution and resolution in-game are mismatched it will take longer to Alt+Tab due to your monitor having to change it's resolution everytime you exit to desktop (e.g. 1280x720 -> 1920x1080). This can be completely eliminated by changing your desktop resolution to the one you are using in-game. Make sure you change the resolution with your GPU's control panel, changing the resolution in Windows settings does not change it properly!

[^3]: How sharp the image is gonna be depends on the quality of your monitor's scaler. Different monitors will have different results. I tried this on my Zowie XL2546 and Asus XV252Q and the image was significantly sharper on the Zowie.

[^4]: reset-all.exe - reset all monitor settings back to default; restart64.exe - restarts gpu drivers + opens recovery menu.

[^5]: I recommend you to use Display ID 1.3 since it has better compatibility, you can try and mess around with Display ID 2.0 extension block.