---
title: "Game List Added"
date: 2024-12-28T22:36:11+01:00
lastmod: 2024-12-31T18:45:00+01:00
tags:
- update
description: "I added a list page for all my completed games."
---

Hey!

I just added the first batch of my most favorite games into the [gaming list](/list/games). I thought it might be a cool idea to add such page where I can keep a library of all the games I've finished, how long it took me, when I finished it etc. This could obviously be expanded to series, books and others. (Which I'm obviously going to do later :P)

For this to be possible I made a Hugo shortcode that takes a CSV file as an input and makes a HTML table out of it. My biggest struggle was getting the last modified date printed on the bottom of the page (it's very silly, but I wanted it to be there) - since you are not changing the markdown file itself (in my example `/content/list/games.md`), but the CSV `/assets/games.csv`, I would have to change the lastmod in the header of the markdown file every single time, which is not something that I wanted to do and I know myself.. I would forget to do it. So instead I got a simple one liner that stores the last modified date from `git log` inside `/data/assets.yaml` which I can later retrieve in the shortcode using `.Site.Data`. I made a Makefile to automate this process on every build. This is how it looks:

```
mkdir -p data && > data/assets.yaml && for f in assets/*.*; do echo ${f##*/}: "$( git log --date=format:"%Y-%m-%d %H:%M:%S" --pretty="%ad" -1 $f)" >> data/assets.yaml; done
```

This one-liner creates a directory called `data`, then clears the `data/assets.yaml` file. It then loops through all files inside the `assets` folder, appending each file's name and its last commit date (from Git) to the `assets.yaml` file in the format `filename: commit_date`.

I also added searching functionality to the shortcode with a very simple JavaScript code. Sadly with this change, the 100% JavaScript website dream has come to an end. (Only 99.9% free now :D)

Try taking a look at the list yourself [here](/list/games). I had to go deep down the memory lane to even remember some of those and I will obviously add more games once I remember them!:D

See ya.

> [{{< ref "/list/games" >}}]({{< ref "/list/games" >}})