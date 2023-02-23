---
title: "Deploy Hugo to VPS With GitHub Actions"
date: 2023-02-23T10:43:22+01:00
tags:
  - guide
  - software
  - web
description: "Easily deploy your Hugo project to your VPS with GitHub Actions."
---

This guide is gonna be very similar to the one I've made for Jekyll about a year ago, just tailored towards Hugo instead. So if you would like to deploy Jekyll project instead of Hugo, use [this]({{< ref "deploy-jekyll-to-your-server" >}}) guide. (or if you are lost)

Prerequisites:
- ! [Rsync](https://linux.die.net/man/1/rsync) installed on your VPS !
- GitHub repo with your Hugo project
- HTTP server (e.g. NGINX, Apache, ...)

As with the previous guide, I will be using NGINX to serve my website. If you don't have NGINX up and running on your server, you can find an example docker compose [here](https://github.com/xaizone/docker-compose-examples). Also as I mentioned above, without rsync this won't work, so install rsync on your VPS. (apt install rsync, yum install rsync, pacman -S rsync)

Start by creating a `.github` directory with a `workflows` subdirectory in your project's root folder, inside of the workflows folder create a yml file with any name. I called mine `ci.yml`. In the end your folder structure is gonna look something like this - `./.github/workflows/ci.yml`

Now you want to start defining your workflow inside the ci.yml file, I've included mine below as a reference, feel free to edit it for your needs. Read the comments of the YAML file if you are lost.

ci.yml
```yml
# name of your action
name: ci

on:
  push:
    branches:
    # only run the action when you push to main branch
      - main
    paths-ignore:
    # don't run the action if any of these files are modified
      - 'README.md' 
      - '.gitignore'

  # adds ability to run the action manually from the actions tab on github
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    # checkout the latest commit
    - uses: actions/checkout@v3
    # setup hugo
    - name: setup hugo
      uses: peaceiris/actions-hugo@v2
      with:
        hugo-version: 'latest'
    # build your project
    - name: build hugo
      run: hugo --minify
    # deploy to vps using rsync
    - name: deploy website
      uses: easingthemes/ssh-deploy@main
      env:
        ARGS: "-vrp --delete"
        # github secret - https://docs.github.com/en/actions/security-guides/encrypted-secrets
        SSH_PRIVATE_KEY: ${{ secrets.key }} # you can use password instead, check the docs
        REMOTE_HOST: ${{ secrets.host }}
        REMOTE_PORT: ${{ secrets.port }}
        REMOTE_USER: ${{ secrets.user }}
        # change this to your nginx page root
        TARGET: "~/www/nginx"
        SOURCE: "public/"
```

You can see that I'm using GitHub secrets to hide sensitive information in the workflow file. Here's how you set them up:

Go to your GitHub repo and click on the Settings tab. On the left you will find `Secrets and variables` -> `Actions`, add your secrets in there, in my case it's `KEY`, `HOST`, `PORT`, `USER`.

And if you've setup everything correctly, when you push to main branch it will build the website and automatically deploy it to your VPS.