---
title: "Easy way to deploy Jekyll site to self-hosted NGINX using GitHub"
date: 2022-02-19
tags: 
  - guide
  - code
  - github
---
today i'll show you how you can easily deploy jekyll websites to your server with [github actions](https://docs.github.com/en/actions).

all you need is a way to serve the page on your server - in my case i will be using nginx

everything else like building the jekyll website and deploying it, will be done on github side, thanks to github actions

prerequisites:
- github repo with your jekyll website
- self-hosted nginx

you want to start by making `.github/workflows` folder in your repo, here you will make your github workflow file - `main.yml` (or any other name of your liking e.g. deploy.yml)

directory tree
```
.github
└── workflows
    └── main.yml
```

main.yml
```
name: deploy on push # optional

on: 
  push:
    branches:
      - main # only on main branch

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
        jekyll_build_options: "-d ./build" # changes building directory to ./build, default caused some issues
        build_only: true # only builds the website, by default it deploys to gh-pages
    - uses: easingthemes/ssh-deploy@main
      env:
        ARGS: "-vrp --delete" # verbose, recursive, preserve permissions, delete extraneous files from destination
        SSH_PRIVATE_KEY: ${{ secrets.SSH_KEY }}
        REMOTE_HOST: ${{ secrets.REMOTE_HOST }}
        REMOTE_PORT: ${{ secrets.REMOTE_PORT }}
        REMOTE_USER: ${{ secrets.REMOTE_USER }}
        TARGET: "~/www/xaizone.eu"
        SOURCE: "build/"
```

now let me explain what everything does:

1. [actions/checkout](https://github.com/actions/checkout) - gets the latest commit from your github repo
2. [actions/cache](https://github.com/actions/cache) - used to shorten build times and load on github servers by caching dependencies
3. [helaili/jekyll-action](https://github.com/helaili/jekyll-action) - build your jekyll website
4. [easingthemes/ssh-deploy](https://github.com/easingthemes/ssh-deploy) - deploy to your server with rsync

change `TARGET: "~/www/xaizone.eu"` to folder[^1] where you serve your website with nginx.

you may ask, what is `{{secrets.<BLABLA>}}` ?

it's a [github secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets), you can set them up in your github repo, it allows you to store sensitive information like ssh-key, host, etc.

use github docs that i've linked above and set them up in your repository.

you want to have these secrets:
- `SSH_KEY` - private ssh key for your server
- `REMOTE_HOST` - ip/hostname of your server
- `REMOTE_PORT` - ssh port (you can remove this line if you are using default port - 22)
- `REMOTE_USER` - ssh user (e.g. peter)

and that's it! 

github will now take care of building and deploying your jekyll website to your server.

[^1]: this depends on your server structure, default for nginx is `/usr/local/nginx/html/`