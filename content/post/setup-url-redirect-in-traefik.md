---
title: "Setup URL Redirect in Traefik"
date: 2022-11-25T10:08:58+01:00
tags:
  - linux
  - docker
  - guide
description: "How to setup a redirect from old domain to a new one using Traefik"
---

This article will help you setup a redirect from your old domain to a new one without an external service using Traefik.

Official Traefik documentation can be confusing at times and some stuff that we will be using today is completely missing from it, so I thought writing an article might help some people in the future.

Assumptions:
- Basic knowledge of Traefik
- Understanding of how containers work
- You know why HTTPS is necessary and you will use it

Prerequisites:
- Correctly setup providers in static Traefik configuration
- Dynamic Traefik configuration file

If you don't meet the prerequisites, you can check my example Traefik configuration [here](https://github.com/xaizone/docker-compose-examples/). (GitHub Repository)

You will want to start by adding a new middleware to your dynamic Traefik configuration file, in my case `dynamic.yml`.

```yml
# dynamic configuration file
http:
  middlewares:
    redirect-new-domain:
      redirectregex:
        # redirect everything
        regex: ".*"
        # new domain redirect
        replacement: "https://new-example.com"
```

You can declare that the redirect is permanent by adding `permanent: true` in your redirectregex middleware. 

Now after you've setup your new middleware, you will want to add a new route in the same file:

```yml
# dynamic configuration file
http:
  routers:
    example-com:
      # change to your entrypoint!
      entrypoints: websecure
      # regex to include all subdomains
      rule: HostRegexp(`example.com`,`{subdomain:.*}.example.com`) 
      # redirect middleware
      middlewares: redirect-new-domain
      # dummy service from traefik
      service: noop@internal
      tls:
        # adjust to your certresolver
        certresolver: cloudflare 
```

And that's it!

Traefik will now redirect all requests from your old domain (example.com, *.example.com) to your new domain (new-example.com).

```yml
# final example of dynamic configuration file
http:
  routers:
    example-com:
      # change to your entrypoint!
      entrypoints: websecure
      # regex to include all subdomains
      rule: HostRegexp(`example.com`,`{subdomain:.*}.example.com`) 
      # redirect middleware
      middlewares: redirect-new-domain
      # dummy service from traefik
      service: noop@internal
      tls:
        # adjust to your certresolver
        certresolver: cloudflare 

  middlewares:
    redirect-new-domain:
      redirectregex:
        # redirect everything
        regex: ".*"
        # new domain redirect
        replacement: "https://new-example.com"
```

---

Sources: 
- [Traefik Docs](https://doc.traefik.io/traefik/)
- [Traefik Labs Forum](https://community.traefik.io/t/redirect-to-external-site-without-service/9984/)