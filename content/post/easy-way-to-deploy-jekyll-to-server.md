---
title: "Easy way to deploy Jekyll site to your server using GitHub Actions"
date: 2022-02-19
tags:
  - guide
  - software
  - web
description: "Deploy a Jekyll website to your own server with ease using GitHub Actions."
---
Today I'm gonna show you how you can easily deploy a Jekyll website to your server using [GitHub Actions](https://docs.github.com/en/actions).

All you will need on your server is a way to serve the it (I will be using NGINX, but it doesn't matter).

Everything else like building the website, will be done on GitHub side, thanks to GitHub Actions. Keep in mind that this is basically not unlimited, you get 2000 CI/CD minutes per month in the free [GitHub plan](https://github.com/pricing), which should be more than enough for anything.

Prerequisites:
- GitHub repo with your Jekyll website
- A way to serve it (e.g. NGINX)
- Rsync installed on your server

You want to start by making `.github/workflows` folder in your repository, here you will make your GitHub workflow file - `main.yml` (or anything else e.g. ci.yml, deploy.yml, ...)

directory tree
```
.github
└── workflows
    └── main.yml
```

main.yml
```
# optional - name of your action
name: deploy on push

# run this workflow on push to main branch and ability to run manually
on:
  push:
    branches:
      - main

  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: actions/cache@v2
      with:
        path: vendor/bundle
        key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile') }}
        restore-keys: |
          ${{ runner.os }}-gems-
    - uses: helaili/jekyll-action@v2
      with:
        # change build directory to ./build
        jekyll_build_options: "-d ./build" 
        build_only: true
    - uses: easingthemes/ssh-deploy@main
      env:
        # verbose, recursive, preserve permissions, delete extraneous files from destination
        ARGS: "-vrp --delete" 
        SSH_PRIVATE_KEY: ${{ secrets.SSH_KEY }}
        REMOTE_HOST: ${{ secrets.REMOTE_HOST }}
        REMOTE_PORT: ${{ secrets.REMOTE_PORT }}
        REMOTE_USER: ${{ secrets.REMOTE_USER }}
        TARGET: "~/www/xaizone.eu"
        SOURCE: "build/"
```

Now let me explain what it does:

1. [actions/checkout](https://github.com/actions/checkout) - gets latest commit from your repo
2. [actions/cache](https://github.com/actions/cache) - shorter build times and less load on github servers by caching dependencies
3. [helaili/jekyll-action](https://github.com/helaili/jekyll-action) - build your jekyll website
4. [easingthemes/ssh-deploy](https://github.com/easingthemes/ssh-deploy) - deploy to your server with rsync

Change `TARGET: "~/www/xaizone.eu"` to the folder where you run your web server.

You may ask, what is `{{secrets.<XXX>}}` ?

It's a [GitHub Secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets), you can set them up in your github repository. It allows you to store sensitive information like private ssh key, without exposing it!

Use GitHub docs that I've linked above and set them up in your repository accordingly.

Add these secrets:
- `SSH_KEY` - private ssh key for your server
- `REMOTE_HOST` - ip of your server
- `REMOTE_PORT` - ssh port (you can remove this line if you are using the default port - 22)
- `REMOTE_USER` - ssh user

and that's it! 

github will now take care of building and deploying your jekyll website to your server.