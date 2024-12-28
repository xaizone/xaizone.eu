---
title: "Game List Added"
date: 2024-12-28T22:36:11+01:00
tags:
- update
description: "I added a list page for all my completed games."
---

Hey!

I just added the first batch of my most favorite games into the [gaming list](/list/games). I thought it might be a cool idea to add such page where I can keep a library of all the games I've finished, how long it took me, when I finished it etc. This could obviously be expanded to series, books and others. (Which I'm obviously going to do later :P)

For this to be possible I made a Hugo shortcode that takes a CSV file as an input and makes a HTML table out of it. My biggest struggle was getting the last modified date printed on the bottom of the page (it's very silly, but I wanted it to be there) - since you are not changing the markdown file itself (in my example `/content/list/games.md`), but the CSV `/assets/games.csv`, I would have to change the lastmod in the header of the markdown file every single time, which is not something that I wanted to do and I know myself.. I would forget to do it. So instead I found a function named `os.Stat` which lets you get the last modified date from the file metadata. This function needs a complete path to the file so taking it from the parameter of the shortcode was not possible and I had to hardcode the `/assets` folder into the function. I couldn't find a way to get the full path, it would always return the path without `/assets`.

Maybe in the future I will find a better way to do this, but for now this is the best I could do.

Try taking a look at the list yourself [here](/list/games). I had to go deep down the memory lane to even remember some of those and I will obviously add more games once I remember them!:D

See ya.

> [{{< ref "/list/games" >}}]({{< ref "/list/games" >}})